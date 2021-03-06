class PublicationsController < ApplicationController
  before_action :set_publication, only: [:show, :edit, :update, :destroy]

  # GET /publications
  # GET /publications.json
  def index
    friends=current_user.friendships.where(type: "confirmed").pluck(:friend)
    @publications=Publication.where(:id.in =>Shared_publication.where(:user.in => friends).distinct(:publication))
  end

  # GET /publications/1
  # GET /publications/1.json
  def show
  end

  # GET /publications/new
  def new
    @publication = Publication.new
  end

  # GET /publications/1/edit
  def edit
    if !(current_user.role="admin" or @publication.user==current_user)
		not_autorized
		reload
	end
  end

  # POST /publications
  # POST /publications.json
  def create
    @publication = Publication.new
    @publication.text=publication_params["text"]
    image=publication_params["image"]
    @publication.user=current_user
    
    shared=Shared_publication.new
    shared.user=current_user
    respond_to do |format|
      if @publication.save
        shared=Shared_publication.new
        shared.user=current_user
        shared.publication=@publication
        shared.save
        if image
        	path="publication_images/#{@publication.id}.im"
        	FileUtils.copy_stream(image,Rails.root+"public/"+path)
        	@publication.update(image: path)
        end
        format.html { redirect_to @publication, notice: 'Publication was successfully created.' }
        format.json { render :show, status: :created, location: @publication }
      else
        format.html { render :new }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publications/1
  # PATCH/PUT /publications/1.json
  def update
	if current_user.role="admin" or @publication.user==current_user
		respond_to do |format|
		  if @publication.update(text: publication_params[:text])
		    image=publication_params["image"]
		    if image
		 		path="publication_images/#{@publication.id}.im"
		    	FileUtils.copy_stream(image,Rails.root+"public/"+path)
		    	@publication.update(image: path)
		 	end
			format.html { redirect_to @publication, notice: 'Publication was successfully updated.' }
			format.json { render :show, status: :ok, location: @publication }
		  else
			format.html { render :edit }
			format.json { render json: @publication.errors, status: :unprocessable_entity }
		  end
		end
	else
		not_autorized
		reload
	end
  end

  # DELETE /publications/1
  # DELETE /publications/1.json
  def destroy
    if current_user.role="admin" or @publication.user==current_user
		Shared_publication.where(publication: @publication).destroy
		@publication.destroy
		respond_to do |format|
		  format.html { redirect_to publications_url, notice: 'Publication was successfully destroyed.' }
		  format.json { head :no_content }
		end
	else
		not_autorized
		reload
	end
  end
  
  def share
	set_publication
	@shared=Shared_publication.new
	@shared.publication=@publication
	@shared.user=current_user
	@shared.save
	reload
  end
  
  def unshare
  	if @shared=Shared_publication.find(params[:id])
  		if current_user.role="admin" or @shared.user==current_user
	  		@shared.destroy
	  	else
	  		not_autorized
	  	end
	  	reload
  	else
  		not_found
  	end
  end
  
  def like
  	set_publication
  	@like=Like.new
  	@like.publication=@publication
  	@like.user=current_user
  	@like.save
  	reload
  end
  
  def dislike
  	if @like=Like.find(params[:id])
  		if current_user.role="admin" or @like.user==current_user
	  		@like.destroy
	  	else
	  		not_autorized
	  	end
	  	reload
  	else
  		not_found
  	end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publication
      @publication = Publication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def publication_params
      params.fetch(:publication, {})
    end
end

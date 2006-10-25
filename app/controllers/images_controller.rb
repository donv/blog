class ImagesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @image_pages, @images = paginate :images, :per_page => 10
  end

  def show
    @image = Image.find(params[:id])
    send_data(@image.picture_data,
#              :filename     => @image.title,
              :filename     => "Blog Image #{@image.id}",
              :type         => @image.picture_content_type,
              :disposition  => "inline")
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(params[:image])
    if @image.save
      flash[:notice] = 'Image was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])
    if @image.update_attributes(params[:image])
      flash[:notice] = 'Image was successfully updated.'
      redirect_to :action => 'show', :id => @image
    else
      render :action => 'edit'
    end
  end

  def destroy
    Image.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

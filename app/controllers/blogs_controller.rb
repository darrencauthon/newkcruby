class BlogsController < ApplicationController

  layout 'application'
  before_action :set_blog, only: [:show, :update]

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.paginate(page: params[:page], per_page: 5)
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @blog = Blog.find(params[:id])
  end

  # GET /blogs/new
  def new
    if current_user == nil 
      redirect_to new_session_path
    else
      @blog = Blog.new
    end
  end

  # GET /blogs/1/edit
  def edit
    @blog = current_user.blogs.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to blogs_path, notice: "You cannot edit this event."
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = current_user.blogs.build(blog_params)
    if @blog.save
      redirect_to @blog, notice: 'Blog was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog = current_user.blogs.find params[:id]
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :message)
    end
end

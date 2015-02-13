class PagesController < ApplicationController
  before_action :set_page, only: [:show, :destroy]

  before_filter :init_fb_graph_api

  # GET /pages/1
  # GET /pages/1.json
  def show
    begin
      @feeds = @graph.get_connections( @page.page_id.to_i, "feed?limit=10")
    rescue Koala::Facebook::ClientError => exc
      redirect_to root_url, notice: "Nous avons rencontre un probleme, veuillez reessayer."
    end
  end

  # GET /pages/new
  def new
    @page = Page.new
    @pages = Page.all
  end


  # POST /pages
  # POST /pages.json
  def create
    begin
      fbpage = @graph.get_object(params['page']['page_id'].to_i)
      picture = @graph.get_picture(params['page']['page_id'].to_i)
    rescue Koala::Facebook::ClientError => exc
      error = true
      redirect_to root_url
    end

    unless error
      params["page"]["name"] = fbpage['name']
      params["page"]["picture"] = picture
      @page = Page.new(page_params)

      respond_to do |format|
        if @page.save
          format.js   { }
          format.json { render json: @page, status: :created, location: @page }
        else
          format.html { render action: "new" }
          format.json { render json: @page.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:page_id, :name, :picture)
    end
end

class WikisController < ApplicationController
  before_action :set_wiki, only: %i[ show edit update destroy ]

  # GET /wikis or /wikis.json
  def index
    @wikis = Wiki.all
  end

  # GET /wikis/1 or /wikis/1.json
  def show
  end

  # GET /wikis/new
  def new
    @wiki = Wiki.new
  end

  # GET /wikis/1/edit
  def edit
  end

  # POST /wikis or /wikis.json
  def create
    @wiki = Wiki.new(wiki_params)

    respond_to do |format|
      if @wiki.save
        format.html { redirect_to @wiki, notice: "Wiki was successfully created." }
        format.json { render :show, status: :created, location: @wiki }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @wiki.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /wikis/1 or /wikis/1.json
  def update
    respond_to do |format|
      if @wiki.update(wiki_params)
        format.html { redirect_to @wiki, notice: "Wiki was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @wiki }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @wiki.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /wikis/1 or /wikis/1.json
  def destroy
    @wiki.destroy!

    respond_to do |format|
      format.html { redirect_to wikis_path, notice: "Wiki was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki
      @wiki = Wiki.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def wiki_params
      params.expect(wiki: [ :title, :body, :user_id ])
    end
end

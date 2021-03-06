class PoemsController < ApplicationController
  before_action :set_poem, only: [:show, :edit, :update, :destroy]
  layout 'poettree'

  layout 'editor', only: ['show']


  # GET /poems
  # GET /poems.json
  def index
    @poems = Poem.search(params[:search]).page params[:page]
  end

  def poem_editor
    @poems = Poem.all
  end

  def search
    puts "\nPARAMS#{params[:search]}\n"
    @poems = Poem.where('title LIKE ? OR body LIKE ?', params[:search], params[:search])
  end
  
  def my_poems
    
    @poems = current_user.poems.page params[:page]
    
    render 'index'
  end

  # GET /poems/1
  # GET /poems/1.json
  def show
  end

  # GET /poems/new
  def new
    @poem = Poem.new
  end

  # GET /poems/1/edit
  def edit
  end

  # POST /poems
  # POST /poems.json
  def create
    @poem = Poem.new(poem_params)

    respond_to do |format|
      if @poem.save
        format.html { redirect_back(fallback_location: root_path) }
        format.json { render :show, status: :created, location: @poem }
      else
        format.html { redirect_back(fallback_location: root_path) }
        format.json { render json: @poem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /poems/1
  # PATCH/PUT /poems/1.json
  def update
    respond_to do |format|
      if @poem.update(poem_params)
        format.html { redirect_back(fallback_location: root_path)  }
        format.json { render :show, status: :ok, location: @poem }
      else
        format.html { redirect_back(fallback_location: root_path) }
        format.json { render json: @poem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /poems/1
  # DELETE /poems/1.json
  def destroy
    @poem.destroy
    respond_to do |format|
      format.html { redirect_to poems_url, notice: 'Poem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poem
      @poem = Poem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poem_params
      params.require(:poem).permit(:title, :body, :user_id, :image_url, :shared, :lesson_id, :author_name)
    end
end

class LessonsController < ApplicationController
  
  layout 'editor', except: ['show']
  
  before_action :set_lesson, only: [:show, :edit, :update, :destroy, :complete]
  before_action :set_lesson_group, only: [:show, :edit, :update, :destroy, :new, :index]


  # GET /lessons
  # GET /lessons.json
  def index
    @lessons = @lesson_group.lessons
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
    @poem = Poem.find_by(user_id: current_user.id, lesson_id: @lesson.id) || Poem.new
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new(lesson_group_id: @lesson_group.id)
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.lesson_group_id = params[:lesson_group_id]

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to "/lesson_groups/#{params[:lesson_group_id]}/lessons/#{@lesson.id}", notice: 'Lesson was successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def complete
    current_user.lesson_completeds.create(lesson_id: @lesson.id) if current_user.lesson_completeds.where(lesson_id: @lesson.id).first.nil?
    
    redirect_to current_user.next_lesson_with_group
  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to "/lesson_groups/#{@lesson_group.id}/lessons/#{@lesson.id}", notice: 'Lesson was successfully updated.' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to lessons_url, notice: 'Lesson was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end
    
    def set_lesson_group
      puts "\n#{params[:lesson_group_id]}\n"
      @lesson_group = LessonGroup.find(params[:lesson_group_id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:title, :content, :order, :lesson_type, :lesson_group_id, :video_link)
    end
end

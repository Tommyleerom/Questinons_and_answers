class QuestionsController < ApplicationController
  before_action :set_question!, only: %i[edit update destroy show]

  def index
    @questions = Question.all
  end

  def new # new - форму отображает, а create обрабатывает
    @question = Question.new
  end

  def create # create - форму обрабатывает, а new отображает
    @question = Question.new question_params
    if @question.save
      flash[:success] = 'Question created!'
      redirect_to questions_path
    else
      render :new
    end
  end

  def edit # edit -форму отображает, а update обрабатывает
  end

  def update # update - форму обрабатывает, а edit отображает
    if @question.update question_params
      flash[:success] = 'Question updated!'
      redirect_to questions_path
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = 'Question deleted!'
      redirect_to questions_path
    else
      render json: @question.errors
    end
  end

  def show
    @answer = @question.answers.build # build т.к. мы создаем новый объект через ассоциации
    @answers = @question.answers.order created_at: :desc
  end

  private

  def set_question!
    @question = Question.find params[:id]
                                #id - это столбец из базы данных по которому будем искать id который указан в params
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end

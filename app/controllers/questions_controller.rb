class QuestionsController < ApplicationController

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
    @question = Question.find_by id: params[:id]
                                #id - это столбец из базы данных по которому будем искать id который указан в params
  end

  def update # update - форму обрабатывает, а edit отображает
    @question = Question.find_by id: params[:id]
    if @question.update question_params
      flash[:success] = 'Question updated!'
      redirect_to questions_path
    else
      render :edit
    end
  end

  def destroy
    @question = Question.find_by id: params[:id]
    if @question.destroy
      flash[:success] = 'Question deleted!'
      redirect_to questions_path
    else
      render json: @question.errors
    end
  end

  def show
    @question = Question.find_by id: params[:id]
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

end

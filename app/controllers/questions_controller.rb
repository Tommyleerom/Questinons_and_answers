# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question!, only: %i[edit update destroy show]

  def index
    @pagy, @questions = pagy Question.order(created_at: :desc)
  end

  # new - форму отображает, а create обрабатывает
  def new
    @question = Question.new
  end

  # create - форму обрабатывает, а new отображает
  def create
    @question = Question.new question_params
    if @question.save
      flash[:success] = t('.success')
      redirect_to questions_path
    else
      render :new
    end
  end

  # edit -форму отображает, а update обрабатывает
  def edit; end

  # update - форму обрабатывает, а edit отображает
  def update
    if @question.update question_params
      flash[:success] = t('.success')
      redirect_to questions_path
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = t('.success')
      redirect_to questions_path
    else
      render json: @question.errors
    end
  end

  def show
    @answer = @question.answers.build # build т.к. мы создаем новый объект через ассоциации
    @pagy, @answers = pagy @question.answers.order(created_at: :desc)
  end

  private

  def set_question!
    @question = Question.find params[:id]
    # id - это столбец из базы данных по которому будем искать id который указан в params
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end

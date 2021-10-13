# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :set_answer!, only: %i[destroy edit update]

  def create
    @question = Question.find params[:question_id]
    @answer = @question.answers.build answer_params
    if @answer.save
      flash[:success] = 'Answer created!'
      redirect_to question_path(@question)
    else
      @pagy, @answers = pagy @question.answers.order(created_at: :desc)
      # эту строчку нужно вставить т.к. в противном случае эта переменная
      # не будет определена и при отправлке пустой формы будет nil и соответствующая
      # ошибка, а render в отличие от redirect_to не обновляет переменные
      render '/questions/show'
    end
  end

  def edit; end

  def update
    if @answer.update answer_params
      flash[:success] = 'Answer updated!'
      redirect_to question_path(@question, anchor: "answer-#{@answer.id}")
      # будет редиректиться сразу к отредактированному ответу
    else
      render :edit
    end
  end

  def destroy
    if @answer.destroy
      flash[:success] = 'Answer deleted!'
      redirect_to question_path(@question)
    else
      render json: @answer.errors
    end
  end

  private

  # ! - т.к. этот метод может вернуть ошибку если искомый id не существует
  def set_answer!
    @question = Question.find params[:question_id]
    @answer = @question.answers.find params[:id]
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end

module ApplicationHelper
  include Pagy::Frontend

  def full_title(page_title = "")
    base_title = "AskIt"
    page_title.present? ? "#{page_title} | #{base_title}" : base_title
  end

  def pagynate
    pagy_bootstrap_nav @pagy if @pagy.pages > 1
  end

end

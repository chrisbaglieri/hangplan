class PagesController < ApplicationController
  def home
    if user_signed_in?
      flash.keep
      redirect_to plans_path
    end
  end

  def about
  end

  def contact
  end

  def faq
  end
end

class PagesController < ApplicationController
  skip_before_action :set_locale

  def home
    EmailTemplate.last.compile_with_vars(Person.last)
    if current_admin_user
      render :admin
    else
      render :home
    end
  end

  def admin
  end

end

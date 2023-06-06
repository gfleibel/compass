class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home contact resources conduct]
  def home
  end
  def contact
  end
  def resources
  end
  def conduct
  end
end

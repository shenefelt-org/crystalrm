class HomeController < ApplicationController
  def crystalrm
    @wikis = Wiki.all
  end

  def index
  end
end

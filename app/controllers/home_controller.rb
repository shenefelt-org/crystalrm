class HomeController < ApplicationController

  def crystalrm
    @wikis = Wiki.all
  end
end
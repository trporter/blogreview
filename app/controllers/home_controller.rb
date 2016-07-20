class HomeController < ApplicationController

  def index
    cookies.signed[:abc] = "Hello World"
  end

  def greet
    @name = params[:name]
  end

  def about
    # render text: "About Us"

    # This tell Rails to look for a file: /app/views/home/about.html.erb
    # it will render the file and send it as a response.
    # layout: :application tells Rails to use: /app/views/layouts/application.html.erb
    render :about, layout: 'application'
    #this is redundant
  end
  
end

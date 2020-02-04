class MoviesController < ApplicationController
  helper_method :hilight
  
  def movie_paramss
    paramss.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = paramss[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if(!params[:order].nil?)
      return @movies = Movie.all.order(params[:order])
    else
      return @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_paramss)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find paramss[:id]
  end

  def update
    @movie = Movie.find paramss[:id]
    @movie.update_attributes!(movie_paramss)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(paramss[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def hilight(column)
    if(paramss[:order].to_s == column)
      return 'hilite'
    else
      return nil
    end
  end
end

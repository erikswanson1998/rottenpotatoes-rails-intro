class MoviesController < ApplicationController
  helper_method :hilight
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    
    if(!params[:order].nil?)
      if(!params[:ratings].nil?)
        return @movies = Movie.where(rating: params[:ratings].keys).order(params[:order])
      else
        return @movies = Movie.order(params[:order])
      end
    elsif(!params[:ratings].nil?)
      return @movies = Movie.where(rating: params[:ratings].keys)
    else
      return @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def hilight(column)
    if(params[:order].to_s == column)
      return 'hilite'
    else
      return nil
    end
  end
end

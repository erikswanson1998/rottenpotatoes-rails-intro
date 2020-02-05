class MoviesController < ApplicationController
  helper_method :hilight
  helper_method :is_rating
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
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    session[:order] = params[:order] unless params[:order].nil?
    
    if(params[:order].nil? && !session[:order].nil?) || (params[:ratings].nil? && !session[:ratings].nil?)
      redirect_to movies_path("order" => session[:order], "ratings" => session[:ratings])
    elsif(!params[:ratings].nil? || !params[:order].nil?)
      if(!params[:ratings].nil?)
        return @movies = Movie.where(rating: session[:ratings].keys).order(session[:order])
      else
        return @movies = Movie.all.order(session[:order])
      end
    elsif (!session[:ratings].nil? || !session[:order].nil?)
      redirect_to movies_path("order" => session[:order], "ratings" => session[:ratings])
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
  
  def is_rating(rating)
    ratings = params[:ratings]
    if(ratings.nil?)
      return true
    end
    ratings.include? rating
  end
  
end

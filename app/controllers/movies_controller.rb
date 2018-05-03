class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # To generate the filter check boxes
    @all_ratings = Movie.all_ratings
    # To display only selected rated films
    @selected_ratings = @all_ratings
    if params[:ratings]
      @selected_ratings = params[:ratings].keys
      @movies = Movie.all.where(rating: @selected_ratings)
    else
      @movies = Movie.all
    end
    
    # Sort by selected column header
    @sort = nil
    if params[:sortby] == 'title'
      @sort = 'title'
      @movies = @movies.sort_by {|m| m.title }
    elsif params[:sortby] == 'release_date'
      @sort = 'release_date'
      @movies = @movies.sort_by {|m| m.release_date }
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

end

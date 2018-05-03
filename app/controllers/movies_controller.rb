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
    # Navigated to index via Ratings filter
    if params[:ratings]
      @selected_ratings = params[:ratings]
        if @selected_ratings.respond_to? :keys
          @selected_ratings = @selected_ratings.keys
        end
      @movies = Movie.where(rating: @selected_ratings)
      session[:rate] = @selected_ratings
    # Navigated to index another way, check for previous filter settings
    elsif session[:rate]
      @selected_ratings = session[:rate]
      @movies = Movie.where(rating: @selected_ratings)
    # No ratings filter set -> check & display all
    else
      @selected_ratings = @all_ratings
      @movies = Movie.all
    end
    
    # Sort by selected column header
    if params[:sortby] == 'title' || params[:sortby] == 'release_date'
      @sort = params[:sortby]
      @movies = @movies.sort_by &@sort.to_sym
      session[:sort] = @sort
    elsif session[:sort]
      @sort = session[:sort]
      @movies = @movies.sort_by &@sort.to_sym
    end

    if (session[:rate] && params[:ratings] == nil) || (session[:sort] && params[:sortby] == nil)
      flash.keep
      redirect_to movies_path({ :ratings => @selected_ratings, :sortby => @sort })
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

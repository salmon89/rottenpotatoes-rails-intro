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
    # @movies = Movie.all
    @sortorder = "asc"

    @ratings = params[:ratings]
    @sort_by = params[:sort_by]


    if @ratings and @ratings.size > 0
       selratings = []
       @ratings.each {|k, v| selratings.push (k) if v}
       @movies = Movie.where("rating in (?)", selratings)
    else
       @movies = Movie.all
       @ratings = {}
    end
    if Movie.column_names.include? @sort_by
      case @sort_by
        when 'title'
          @movies = @movies.order("title ASC").all
        when 'release_date'
          @movies = @movies.order("release_date ASC").all
      end
    end
    @all_ratings = Movie::RATINGS
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
  
  def sort_bytitle
    @movies = Movie.order("title ASC").all
  end

  def sort_bydate
    @movies = Movie.order("release_date ASC").all
  end
end

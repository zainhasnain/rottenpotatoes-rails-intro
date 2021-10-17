class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    persist_ratings = false
    persist_order = false
    
    order = params[:order]
    if !order.nil?
      session[:order] = order
    else
      order = session[:order]
    end
    
    if order == "title"
      @title_header = "hilite bg-warning"
    elsif order == "release_date"
      @date_header = "hilite bg-warning"
    end
    
    ratings = params[:ratings]
    if !ratings.nil?
      @ratings_to_show = ratings.keys
      session[:ratings] = ratings
    else
      if !session[:ratings].nil?
        @ratings_to_show = session[:ratings].keys
      else
        @ratings_to_show = @all_ratings
      end
    end
    if params[:ratings].nil? and params[:order].nil?
      redirect_to(movies_path("order": order, "ratings": Hash[@ratings_to_show.map {|x| [x, '1'] }]))
    else
      @movies = Movie.with_ratings(@ratings_to_show, order)
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

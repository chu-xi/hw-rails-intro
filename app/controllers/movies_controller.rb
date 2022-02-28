class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = %w[G PG PG-13 R]
      rating_filter = params[:ratings]
      if rating_filter != nil
        session[:rating_filter] = rating_filter
      end
      @rating_filter = session[:rating_filter]
      order = params[:sort_by]
      if order != nil 
        session[:order] = order
      end
      
      if session[:order] == nil
        @movies = Movie.all()
      else
        @movies = Movie.all().order(session[:order])
        if session[:order] == 'title'
          @title_hilite = 'bg-warning'
        elsif session[:order] == 'release_date'
          @date_hilite = 'bg-warning'
        end 
      end
      if session[:rating_filter] != nil
        @movies = @movies.select{ |movie| session[:rating_filter].include? movie.rating}
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
class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    get_all_ratings
    if params.has_key?(:ratings)
       params[:ratings].keys.map{|x| @checked_boxes[x] = true}
       @movies = Movie.where(:rating => params[:ratings].keys)
      end
    if params.has_key? :sort_by
      if @movies.nil? || @movies.empty?
        @movies = Movie.order params[:sort_by]
      else
        @movies = @movies.order params[:sort_by]
      end
      if params[:sort_by] == 'title'
        @hilite_title_header = 'hilite'
      elsif params[:sort_by] == 'release_date'
        @hilite_date_header = 'hilite'
      end
    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def get_all_ratings
    @all_ratings =[]
    Movie.select(:rating).map{|movie| @all_ratings.push(movie.rating)}
    @all_ratings = @all_ratings.uniq.sort
    if @checked_boxes.nil?
      @checked_boxes = {}
    end
    @all_ratings.map{|x| @checked_boxes[x] = false}
  end 

end

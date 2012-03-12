class Movie < ActiveRecord::Base

  def self.all_ratings
    Movie.find_by_sql "SELECT DISTINCT rating FROM movies"
  end
  
end

class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings_list, order_by)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
   
    if ratings_list.empty?
      if !order_by.nil?
        movies = Movie.all.order(order_by)
      else
        movies = Movie.all
      end
    else
      ratings_list.map!(&:upcase)
      if !order_by.nil?
        movies = Movie.where(rating: ratings_list).order(order_by)
      else
        movies = Movie.where(rating: ratings_list)
      end
    end 
    return movies
  end
  
end

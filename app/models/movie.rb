class Movie < ActiveRecord::Base
	def Movie.all_ratings
		rate_options = ['G','PG','PG-13','R','NC-17','X']
		Movie.uniq.pluck(:rating).sort do |a,b|
			rate_options.index(a) <=> rate_options.index(b)
		end
	end
end

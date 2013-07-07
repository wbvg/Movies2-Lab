require 'pry'
require 'pry-debugger'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'httparty'
require 'json'
require 'PG'


get '/home' do
  erb :home
end

get '/aboutus' do
  erb :aboutus
end

get '/seek' do
  erb :seek
end

post '/seek' do
  @url = "http://www.omdbapi.com/?i=&t=#{params[:title_search].gsub(" ", "+")}"
  @result = HTTParty.get(@url).gsub("'", " ")
# binding.pry
  @result = JSON(@result)

  @title = @result['Title']
  @year = @result['Year']
  @rated = @result['Rated']
  @director = @result['Director']
  @plot = @result['Plot']
  @poster = @result['Poster']

    sql = "INSERT INTO movies (title, year, rated, released, runtime, genre, director, writers, actors, plot, poster) VALUES
     ('#{@result['Title']}', '#{@result['Year']}', '#{@result['Rated']}','#{@result['Released']}','#{@result['Runtime']}' ,'#{@result['Genre']}','#{@result['Director']}','#{@result['Writers']}', '#{@result['Actors']}','#{@result['Plot']}', '#{@result['Poster']}');"

    conn = PG.connect( :dbname => 'movie_app', :host => 'localhost')
    conn.exec(sql)
    conn.close

 erb :seek
end


 get '/movies' do
    query = "Select poster FROM movies"
    conn = PG.connect( :dbname => 'movie_app', :host => 'localhost')
    @rows = conn.exec(query)
    conn.close

    binding.pry
    erb :poster

end



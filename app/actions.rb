# Homepage (Root path)
get '/' do
  erb :index
end

get '/location' do
  @latitude = params[:lat]
  @longitude = params[:long]
  erb :location
end 
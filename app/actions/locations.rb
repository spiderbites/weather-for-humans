get '/location' do
  @latitude = params[:lat]
  @longitude = params[:long]
  erb :location
end 
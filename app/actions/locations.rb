get '/location' do
  @weather = Weather.new(params)

  erb :location
end

post '/location' do
  @weather = Weather.new(params)

  erb :location
end

helpers do

end
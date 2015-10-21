get '/autocomplete/:q' do
  Autocompleter.complete(params[:q])
end
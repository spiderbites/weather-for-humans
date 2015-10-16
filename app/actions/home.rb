helpers do
  def active_page_vid
    if request.path_info == '/'
      'clouds'
    end
  end
end

get '/' do
  erb :index
end
Weather for Humans
==================
An app that tells you what you need to wear today, not what number it is outside.

## Installation
See https://weather-for-humans.herokuapp.com/

or

1. `bundle install`
2. `rake db:create`, `rake db:migrate`, `rake db:seed`
3. `shotgun -p 3000 -o 0.0.0.0`
4. Visit `http://localhost:3000/` in your browser

### Tech

* [Sinatra] - for the server
* [OpenWeatherMap API] - for the weather
* [GeoNames API] - for place names and geo-coordinates
* [Skeleton] - for the css boilerplate
   
[Sinatra]: http://www.sinatrarb.com/
[OpenWeatherMap API]: http://openweathermap.org/api
[GeoNames API]: http://www.geonames.org/export/web-services.html
[Skeleton]: http://getskeleton.com/
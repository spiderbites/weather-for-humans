$(document).ready(function() {

  $('#gps_link').click(getLocationAndRedirect);

  function getLocationAndRedirect() {
      if (navigator.geolocation) {
          position = navigator.geolocation.getCurrentPosition(function(position) {
            window.location = "/location?lat=" + position.coords.latitude + "&long=" + position.coords.longitude;
          });
      } else {
          // does something better here...
          alert("Geolocation is not supported by this browser.");
      }
  }

  // This code from: http://www.geobytes.com/free-ajax-cities-jsonp-api
  jQuery(function () {
     jQuery("#f_elem_city").autocomplete({
      source: function (request, response) {
       jQuery.getJSON(
        "http://gd.geobytes.com/AutoCompleteCity?callback=?&q="+request.term,
        function (data) {
         response(data);
        }
       );
      },
      minLength: 3,
      select: function (event, ui) {
       var selectedObj = ui.item;
       jQuery("#f_elem_city").val(selectedObj.value);
      return false;
     },
     open: function () {
      jQuery(this).removeClass("ui-corner-all").addClass("ui-corner-top");
     },
     close: function () {
      jQuery(this).removeClass("ui-corner-top").addClass("ui-corner-all");
     }
    });
    jQuery("#f_elem_city").autocomplete("option", "delay", 100);
  });

  var d = new Date();
  var weekday = new Array(7);
  weekday[0]=  "Sunday";
  weekday[1] = "Monday";
  weekday[2] = "Tuesday";
  weekday[3] = "Wednesday";
  weekday[4] = "Thursday";
  weekday[5] = "Friday";
  weekday[6] = "Saturday";

  var n = weekday[d.getDay()];

  $('.day').text(n);

  var time = new Date();
  $('.time').text(time.getHours() + ":" + time.getMinutes() + ":" + time.getSeconds());

  var temperature = JSON.parse($("div[data-temperature]").attr("data-temperature"));

  $('div.temperature').text(temperature.today[0]);
  console.log(temperature, temperature.today[0].toString());
});


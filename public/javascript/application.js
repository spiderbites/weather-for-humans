$(document).ready(function() {

  $('#credits_title').click(function() {
    $('.row.credits').toggle();
  });

  $('#gps_link').click(getLocationAndRedirect);

  function getLocationAndRedirect() {
      if (navigator.geolocation) {
          position = navigator.geolocation.getCurrentPosition(function(position) {
            window.location = "/location?lat=" + position.coords.latitude + "&lon=" + position.coords.longitude;
          });
      } else {
          // does something better here...
          alert("Geolocation is not supported by this browser.");
      }
  }

  // This code from: http://www.geobytes.com/free-ajax-cities-jsonp-api
  // except that we are making the actual call server-side
  jQuery(function () {
     jQuery("#f_elem_city").autocomplete({
      source: function (request, response) {
       jQuery.getJSON(
        "/autocomplete/"+request.term,
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
});
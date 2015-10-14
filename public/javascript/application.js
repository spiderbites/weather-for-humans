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

});


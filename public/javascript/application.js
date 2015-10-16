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


  (function() {
    var counters = {
      day: 0,
      cycle: 0,
      max: {
        days: 3,
        cycles: 7
      }
    }

    var currentDay = function() {
      return counters.day;
    };

    var currentCycle = function() {
      return counters.cycle;
    };

    var nextDay = function() {
      counters.day++;
      if (counters.day === counters.max.days) {
        counters.day = 0;
      };
      return counters.day;
    };

    var nextCycle = function() {
      counters.cycle++;
      if (counters.cycle === counters.max.cycles) {
        counters.cycle = 0;
      };
      return counters.cycle;
    }

    var init = function(config) {
      counters.max = config;
    }

    window.M = {
      init: init,
      currentDay: currentDay,
      currentCycle: currentCycle,
      nextDay: nextDay,
      nextCycle: nextCycle,
    };
  })();

  (function(){
    var data;

    var update = function(day, cycle) {
      $('.day').text(data[day].day);
      $('.time').text(data[day].cycle[cycle].time);
      $('.temperature').text(data[day].cycle[cycle].temperature);
      $('.clothes').text(data[day].cycle[cycle].clothes[0]);
    }

    var init = function(d) {
      data = d;
    }

    window.V = {
      init: init,
      update: update
    };
  })();

  $.get("/data", function(data) {
    M.init({days: data.length, cycles: data[0].cycle.length});

    V.init(data);
    V.update(0, 0);

    $('.day').click(function(){
      M.nextDay();
      V.update(M.currentDay(), M.currentCycle());
    });

    $('.time').click(function(){
      M.nextCycle();
      V.update(M.currentDay(), M.currentCycle());
    });


  })
});


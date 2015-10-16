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

    var diurnalCycles;

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

    var init = function(data) {
      diurnalCycles = data;
      counters.max = { days: data.length,
                       cycles: data[0].cycle.length };
    }

    var getDay = function() {
      return diurnalCycles[currentDay()].day;
    }

    var getTime = function() {
      return diurnalCycles[currentDay()].cycle[currentCycle()].time
    }

    var getTemperature = function() {
      return diurnalCycles[currentDay()].cycle[currentCycle()].temperature
    }

    var getClothes = function() {
      return diurnalCycles[currentDay()].cycle[currentCycle()].clothes
    }


    window.M = {
      init: init,

      getDay: getDay,
      nextDay: nextDay,
      getTime: getTime,
      nextCycle: nextCycle,
      getTemperature: getTemperature,
      getClothes: getClothes
    };
  })();

  (function(){

    var update = function() {
      $('.day').text(M.getDay());
      $('.time').text(M.getTime());
      $('.temperature').text(M.getTemperature());
      $('.clothes').text(M.getClothes()[0]);
      displayTiles();
    }

    var displayTiles = function() {
      clothes = M.getClothes();
      console.log(clothes);
      $('.tiles').remove();
      $('body').append('<div class=tiles></div>');
      clothes.forEach(function(tile) {
        $('.tiles').append("<div class='clothing'> <img src='/images/icons/"+tile+".svg'/> </div>");
      });
    }

    window.V = {
      update: update
    };
  })();

  $.get("/data", function(data) {
    M.init(data);

    V.update();

    $('.day').click(function(){
      M.nextDay();
      V.update();
    });

    $('.time').click(function(){
      M.nextCycle();
      V.update();
    });

  })
});


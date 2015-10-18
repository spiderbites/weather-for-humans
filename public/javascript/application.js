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
                     cycles: data[0].main.length };
  }

  var getDay = function() {
    return 'Monday'
    // return diurnalCycles[currentDay()].day;
  }

  var getTime = function() {
    return 50
    // return diurnalCycles[currentDay()].cycle[currentCycle()].time
  }

  var getTemperature = function() {
    return 20
    // return diurnalCycles[currentDay()].cycle[currentCycle()].temperature
  }

  var getClothes = function() {
    return diurnalCycles[currentDay()].main
    // return diurnalCycles[currentDay()].cycle[currentCycle()].clothes
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
    var clothes = M.getClothes();
    var result = '';
    var result1 = '';
    var result2 = '';
    var three_clothes;

    $('.tiles').remove();
    $('section').append("<div class='tiles'></div>");
    if (clothes.length < 5) {
      clothes.forEach(function(tile) {
        result += renderClothingDiv(2, tile);
      });
      result = renderRowDiv(result);
    }
    else if (clothes.length === 5) {
      three_clothes = clothes.splice(2,3);

      clothes.forEach(function(tile) {
        result1 += renderClothingDiv(2, tile);
      });
      result1 = renderRowDiv(result1);

      three_clothes.forEach(function(tile) {
        result2 += renderClothingDiv(3, tile);
      });
      result2 = renderRowDiv(result2);

      result = result1 + result2;
    }
    else if (clothes.length === 6) {
      three_clothes = clothes.splice(3, 3);

      three_clothes.forEach(function(tile) {
        result1 += renderClothingDiv(3, tile);
      });
      result1 = renderRowDiv(result1);

      clothes.forEach(function(tile) {
        result2 += renderClothingDiv(3, tile);
      });
      result2  = renderRowDiv(result2);
      result = result1 + result2;
    }
    $('.tiles').append(result);
  }

  var boxes = {
    2: " one-half column box",
    3: " one-third column box",
    4: " three columns box"
  };

  var renderRowDiv = function(innerDiv) {
    return "<div class='row'>" + innerDiv + "</div>";
  }

  var renderClothingDiv = function(size, tile) {
    return "<div class='clothing" + boxes[size] + "'>" + renderTileImg(tile) +"</div>";
  };

  var renderTileImg = function(tile) {
    return "<img class='u-max-full-width' src='/images/icons/"+tile+".svg'/>";
  };

  window.V = {
    update: update,
    renderClothingDiv: renderClothingDiv
  };
})();


$(document).ready(function() {

  $('#gps_link').click(getLocationAndRedirect);

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

});


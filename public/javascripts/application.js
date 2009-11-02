// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function(){
    // Document is ready
    var map = new google.maps.Map(document.getElementById("map_div"), {
      zoom: 11,
      center: new google.maps.LatLng(50.0569, 19.9478),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
});
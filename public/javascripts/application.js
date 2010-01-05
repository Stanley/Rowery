// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var map
var marker
var infowindow
var infowindow2
var infowindow3
var poly
var pathCoordinates
var dot
var line_color = {1:"#107dba", 2:"#38a838", 3:"#784e2e", 4:"#aaaaaa", 5:"#69bfb5"}
var marker_icon = {6:"cross", 7:"icon_parking", 9:"pointaaaaaa"}
var lines = []

google.maps.LatLng.prototype.kmTo = function(a){
  var e = Math, ra = e.PI/180
  var b = this.lat() * ra, c = a.lat() * ra, d = b - c
  var g = this.lng() * ra - a.lng() * ra
  var f = 2 * e.asin(e.sqrt(e.pow(e.sin(d/2), 2) + e.cos(b) * e.cos
          (c) * e.pow(e.sin(g/2), 2)))
  return f * 6378.137
}

google.maps.Polyline.prototype.inKm = function(n){
  var a = this.getPath(n), len = a.getLength(), dist = 0
  for(var i=0; i<len-1; i++){
    dist += a.getAt(i).kmTo(a.getAt(i+1))
  }
  return dist
}

function info_window_redy(){
//    alert(infowindow2)
  $(".admin a:not(.destroy)").each(function(){
    $(this).click(function(){
      $.get(this.href, function(data2){
        infowindow2.setContent(data2)
      })
      return false
    })
  })
  $(".admin a.destroy").each(function(){
    $(this).click(function(){
      if (confirm("Czy jesteś pewien?")){
        link = this.href.split("/")
        link.splice(-1,0,"destroy")
        document.location.href = link.join("/")
      }
      return false
    })
  })
}

  $(function(){
    // Document is ready; displaying map
    map = new google.maps.Map(document.getElementById("map_div"), {
      zoom: 12,
      center: new google.maps.LatLng(50.065, 19.9478),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

  //    var icon = new google.maps.MarkerImage({
  //        url: "/images/pointaaaaaa.png",
  //        size: new google.maps.Size(8,8)
  //    })

    var image = new google.maps.MarkerImage("http://maps.gstatic.com/intl/pl_ALL/mapfiles/dd-via.png",
    // This marker is 20 pixels wide by 32 pixels tall.
    new google.maps.Size(11, 11),
    // The origin for this image is 0,0.
    new google.maps.Point(0,0),
    // The anchor for this image is the base of the flagpole at 0,32.
    new google.maps.Point(5, 5));

    dot = new google.maps.Marker({
      icon: image //"/images/pointaaaaaa.png"
    })

    google.maps.event.addListener(dot, 'click', function() {
      $.get("/lines/" + dot.id, function(data){
        var info = new google.maps.InfoWindow({
            content: data
        })

        info.open(map, dot)
        infowindow2 = info

        google.maps.event.addListener(info, 'domready', function(){ info_window_redy() })
      })
    })

    function addLatLng(event) {
        var path = poly.getPath();
        path.insertAt(pathCoordinates.length, event.latLng);

        var str = ""
        poly.getPath().forEach(function(x){str += "[" + x.lat() + "," + x.lng() + "]," })
        $("#line_polyline").attr('value', str.slice(0,-1))
        $("#length").text("Długość: " + Math.round(poly.inKm() * 100) / 100.0 + " km.")
    }

    // Setting up controls on the map
    $('#controls > ul > li:nth-child(2) > a').each(function(){
      $(this).click(function(){
        if(marker){
          infowindow.close()
          marker.setMap(null)
        }
        marker = new google.maps.Marker({
          position: map.center,
          map: map,
          title:"Hello World!",
          draggable: true
        })

        $.get(this.href, function(data){
          infowindow = new google.maps.InfoWindow({
            content: data
          })
          infowindow.open(map, marker)

          google.maps.event.addListener(marker, 'dragend', function() {
            $("#marker_lng").attr('value', marker.position.lng())
            $("#marker_lat").attr('value', marker.position.lat())
          })

          google.maps.event.addListener(infowindow, 'domready', function() {
            google.maps.event.trigger(marker, 'dragend')
          })

          google.maps.event.addListener(infowindow, 'closeclick', function() {
            marker.setMap(null)
          })
        })
        return false
      })
    })

    // Load markers
    $.getJSON('/markers', function(json){
      $.each(json, function(){
        var m = new google.maps.Marker({
          position: new google.maps.LatLng(this.lat, this.lng),
          map: map,
          title: this.name,
          icon: "/images/"+ marker_icon[this.category] +".png"
        })

        var id = this._id

        google.maps.event.addListener(m, 'click', function() {
          if(infowindow2)
            infowindow2.close();

          $.get("/markers/" + id, function(data){
            var info = new google.maps.InfoWindow({
                content: data
            })
            info.open(map, m)
            infowindow2 = info

            google.maps.event.addListener(info, 'domready', function(){ info_window_redy() })
          })
        })
      })
    })

    $.getJSON('/lines', function(json){
      $.each(json, function(){

        var myPath = decodeLine(this.polyline)
        var intervalId
        var color = line_color[this.category]

        var line = new google.maps.Polyline({
          id: this._id,
          path: myPath.map(function(arr){return new google.maps.LatLng(arr[0], arr[1])}),
          strokeColor: color,
          strokeOpacity: 1.0,
          strokeWeight: 2
        });

        line.setMap(map)
        lines.push(line)

        google.maps.event.addListener(line, 'mousemove', function(event){
          clearTimeout(intervalId)
          dot.id = line.id
          dot.setPosition(event.latLng)
          if(!dot.getVisible())
              dot.setMap(map)
          intervalId = window.setInterval("dot.setMap(null)", 1000)
        })
      })
      $('#chceckboxes input').attr('checked', true)
                             .click(function(){
                                toggleLine($(this))
                             })
    })

    $('#add').click(function(){
      if(poly) poly.setMap(null)
      $.ajax({
      // $('#content').load('/lines/new', function(){
        url: '/lines/new',
        error: function(){
          alert("Wystąpił błąd")
        },
        success: function(html){
          $('#content').html(html)
          $('#content').slideDown("slow", function(){
              $("#main").css('border-color','#7EBA10')

              pathCoordinates = new google.maps.MVCArray();
              var polyOptions = {
                path: pathCoordinates,
                strokeColor: '#0000ff',
                strokeOpacity: 0.5,
                strokeWeight: 5
              }

              poly = new google.maps.Polyline(polyOptions);
              poly.setMap(map);

              // Add a listener for the click event
              google.maps.event.addListener(map, 'click', addLatLng);

              $("form .back").click(function(){
                  poly.setMap(null)
                  $("#main").css('border-color', '')
                  $('#content').slideUp("slow")
                  return false
              })
          })
        }
      })
      return false
    });

    $('#content .back').click(function(){
        $('#content').slideUp("slow")
        return false
    });    

});

function decodeLine (encoded) {
  var len = encoded.length;
  var index = 0;
  var array = [];
  var lat = 0;
  var lng = 0;

  while (index < len) {
    var b;
    var shift = 0;
    var result = 0;
    do {
      b = encoded.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    var dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    var dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    array.push([lat * 1e-5, lng * 1e-5]);
  }

  return array;
}

function toggleLine(box){
  var color = line_color[box.attr('rel')]
  var show = box.attr('checked')
  $.each(lines, function(){
    if(this.strokeColor == color){
      if(show)
        this.setMap(map)
      else
        this.setMap(null)
    }
  })
}
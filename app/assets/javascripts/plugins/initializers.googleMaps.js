(function($) {
  var mapInitializers = [];
  var path = [];
  var defaultZoom = 14;
  var lastPosition;
  var polyline;
  var marker;
  var defaultMapCenter = { lat: -34.913283, lng: -57.951501 };
  var unintentialSubmitBlocker = 'onkeypress="if (event.keyCode === 13) { event.preventDefault(); return false; }"';
  var infoWindowContentTemplate = '<div class="window-info">' +
                                  '</div>';
  var mapContainerTemplate = '<div class="map-container"><div class="map-canvas" style="height:500px"></div></div>';

  var referenceContainer = 'div.references'

  var colors = ['33659a', 'b2c9a9', '9f0303', '3f8764', '00a5e6', 'bada55', '0355ba', 'd6fa39', 'b810cb', 'ed123a', '4d2121', '3cb5ba', '268f09']
  var chars = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789*"

  function condition() {
    return ($('[data-google-maps]').length > 0) && ($('.map-container').length == 0);
  }

  function createInfoWindow(map, marker, title, ubication, remainClosed) {
    var infoWindowContent = $(infoWindowContentTemplate);
    if (title) {
      infoWindowContent.html(title);
      $('<strong/>').text(" Repartidor: ").prependTo(infoWindowContent)
    }
    // Create, store a ref to and open the InfoWindow
    var infoWindow = new google.maps.InfoWindow({ content: infoWindowContent.get(0), maxWidth: 240 });
    marker.set('infoWindow', infoWindow);
    if (!remainClosed) {
      infoWindow.open(map, marker);
    }
    return infoWindow;
  }

  function addMarker(map, position, title, id, doNotOpenInfoWindow, iconVisible) {
    if (marker != null) {
      marker.setMap(null);
    }
    marker = new google.maps.Marker({
      map: map,
      position: position,
      title: title,
      animation: google.maps.Animation.BOUNCE,
      icon: 'https://png.icons8.com/scooter/color/48',
      draggable: false,
      visible: iconVisible
    });
    createInfoWindow(map, marker, title, title, doNotOpenInfoWindow);
    marker.addListener('click', handleMarkerClick);
    return marker;
  }

  function addPolyline(map, path) {
    if (polyline != null) {
      var polyPath = polyline.getPath();
      polyPath.push(path[path.length - 1]);
    } else {
      polyline = new google.maps.Polyline({
          map: map,
          path: path,
          strokeColor: '#0000FF',
          strokeOpacity: 0.7,
          strokeWeight: 3
      });
    }
  }

  function randomIntFromInterval(min, max, colorId)
  {
    return colors[Math.floor(Math.random() * min) + max];
  }

  function createContentWindow(map, marker, content, remainClosed) {
    var infoWindowContent = $(infoWindowContentTemplate);
    if (marker.title) {
      $('<strong/>').text(marker.title).appendTo(infoWindowContent)
      //  $('<p/>').text("* " + project).appendTo(infoWindowContent)
      //});
    }
    // Create, store a ref to and open the InfoWindow
    var infoWindow = new google.maps.InfoWindow({ content: infoWindowContent.get(0), maxWidth: 240 });
    marker.set('infoWindow', infoWindow);
    if (!remainClosed) {
      infoWindow.open(map, marker);
    }
    return infoWindow;
  }

  function addFixedMarker(map, marker, doNotOpenInfoWindow) {
    var m = new google.maps.Marker({
      map: map,
      position: marker.position,
      title: marker.title,
      animation: google.maps.Animation.DROP,
      icon: 'https://png.icons8.com/home-address-filled/ios7/32',
      draggable: false
    });
    createContentWindow(map, m, m.title, doNotOpenInfoWindow);
    m.addListener('click', handleMarkerClick);
    return m;
  }

  function addFixedBusinessMarker(map, marker, doNotOpenInfoWindow) {
    var m = new google.maps.Marker({
      map: map,
      position: marker.position,
      title: marker.title,
      animation: google.maps.Animation.DROP,
      icon: 'https://png.icons8.com/home-address-filled/ios7/32',
      draggable: false
    });
    createContentWindow(map, m, m.title, doNotOpenInfoWindow);
    m.addListener('click', handleMarkerClick);
    return m;
  }

  function handleMarkerClick() {
    this.get('infoWindow').open(this.getMap(), this);
  }

  function updatePositions(url, map) {
    var currentPosition;
    $.ajax({
      url: url,
      type: 'GET',
      dataType: 'json',
      async: false,
      success: function (data) {
        currentPosition = data[data.length - 1].position;
        // load markers in the map only if the position changed
        if (lastPositionChange(currentPosition, lastPosition)) {
          drawTrace(data, map);
          lastPosition = data[data.length - 1].position
        }
      }
    });
  }

  function lastPositionChange(currentPosition, lastPosition) {
    if ((lastPosition != null) && (currentPosition != null)) {
      return ((currentPosition.lat != lastPosition.lat) && (currentPosition.lng != lastPosition.lng))
    } else {
      return true
    }
  }

  function drawTrace(traces, map) {
    var marker;
    try {
      var bounds = map.get('bounds') || new google.maps.LatLngBounds();
      var tracesLength = traces.length;
      marker = traces[tracesLength - 1]
      var m = addMarker(map, marker.position, marker.title, marker.id, true, true);
      bounds.extend(m.getPosition());
      $.map(traces, function(trace) {
        path.push(
          new google.maps.LatLng(
            trace.position.lat,
            trace.position.lng
          )
        )
      });
      addPolyline(map, path);
      map.panToBounds(bounds);
      map.set('bounds', bounds);
      map.setCenter(traces[tracesLength - 1].position);
      map.setZoom(defaultZoom);
    } catch(e) {
      if (window.console && console.error) {
        console.error(e);
      }
    }
  }

  function loadMarkers(markers, businessMarker, map) {
    try {
      var bounds = map.get('bounds') || new google.maps.LatLngBounds();
      markers.forEach(function(marker) {
        var m = addFixedMarker(map, marker, true);
        bounds.extend(m.getPosition());
      });
      addFixedBusinessMarker(map, businessMarker, true);
      map.fitBounds(bounds);
      map.set('bounds', bounds);
    } catch(e) {
      if (window.console && console.error) {
        console.error(e);
      }
    }
  }

  function drawPath(map, data) {
    var bounds = map.get('bounds') || new google.maps.LatLngBounds();
    var path = google.maps.geometry.encoding.decodePath(data[0].overview_polyline.points);
    for (var i = 0; i < path.length; i++) {
          bounds.extend(path[i]);
    }
    var polyline = new google.maps.Polyline({
      path: path,
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      map: map
      // strokeColor: "#0000FF",
      //       // strokeOpacity: 1.0,
      //             // strokeWeight: 2
      //
    });
    polyline.setMap(map);
    map.fitBounds(bounds);
  }

  function loadRecommendedPath(map, url) {
    try {
      var recommendedPath;
      $.ajax({
        url: url,
        type: 'GET',
        dataType: 'json',
        async: false,
        success: function (data) {
          drawPath(map, data);
        }
      });
    } catch(e) {
      if (window.console && console.error) {
        console.error(e);
      }
    }
  }


  function createMapInitializer(target, container) {
    var canvas = container.find('.map-canvas');
    var markers = target.data('orders-positions-markers');
    var businessMarker = target.data('business-marker');
    var pathUrl = target.data('recommended-path-url');
    return {
      init: function() {
        var map = new google.maps.Map(canvas.get(0), {
          center: defaultMapCenter,
          zoom: defaultZoom,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        map.setCenter(new google.maps.LatLng(-34.913283, -57.951501));
        // Load recommended path
        loadRecommendedPath(map, pathUrl);
        //Load orders delivery position markers
        loadMarkers(markers, businessMarker, map);
        // Update traces every 5 seconds
        window.setInterval(function(){
          updatePositions(target.data('url'), map);
        }, 1000);
      },
      target: target,
      container: container
    };
  }

  function referenceOptions() {
    var options = {}
    $('.references').data('subject-areas').forEach(function(object){
      options[object.id] = object.attributes.name;
    });
    return options;
  }

  function initializer() {
    var apiKey;
    $('[data-google-maps]').each(function() {
      var $this = $(this);
      apiKey = apiKey || $this.data('google-maps');
      var $container = $(mapContainerTemplate).insertAfter($this);
      mapInitializers.push(createMapInitializer($this, $container));
    });

    // Register global initializer for Google Maps
    window.initializeGoogleMaps = function() {
      $.each(mapInitializers, function(i, initializer) {
        initializer.init.call(initializer.target);
     });
    };

    // Load Google Maps API client script only once
    $(document.body).append('<script async defer src="//maps.googleapis.com/maps/api/js?signed_in=true&libraries=geometry&key=' + apiKey + '&callback=initializeGoogleMaps">');
  }

  Initializers.register('google-maps', initializer, condition);
}(jQuery));

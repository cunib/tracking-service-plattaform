(function($) {
  var mapInitializers = [];
  var path = [];
  var defaultZoom = 16;
  var lastPosition;
  var polyline;
  var polylineTrace;
  var marker;
  var fixedMarkers;
  var addedMarkers = new Array();
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
      kraggable: false,
      visible: iconVisible
    });
    createInfoWindow(map, marker, title, title, doNotOpenInfoWindow);
    marker.addListener('click', handleMarkerClick);
    return marker;
  }

  function addPolyline(map, path) {
    if (polylineTrace != null) {
      var polyPath = polylineTrace.getPath();
      polyPath.push(path[path.length - 1]);
    } else {
      polylineTrace = new google.maps.Polyline({
          map: map,
          path: path,
          strokeColor: '#FF0000',
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
    var icon;
    if (marker.status == "finalized") {
      icon = '/destinationFinalized.png';
    } else {
      if (marker.status == "canceled") {
        icon = '/destinationCanceled.png';
      }
      else {
        icon = '/destination.png';
      }
    }
    var m = new google.maps.Marker({
      map: map,
      position: marker.position,
      title: marker.title,
      animation: google.maps.Animation.DROP,
      icon: icon,
      draggable: false
    });
    addedMarkers[marker.id] = m;
    m.set("id", m.id);
    createContentWindow(map, m, m.title, doNotOpenInfoWindow);
    m.addListener('click', handleMarkerClick);
    updateStatusLabel(marker.id, marker.status);
    return m;
  }

  function updateStatusLabel(id, status) {
    var statusContainer = $('#order-status-' + id + ' span');
    var statusses = { sended: "<span class='label label-success'> Enviado </span>", canceled: "<span class='label label-danger'>Cancelado</span>", finalized: "<span class='label label-success'> Finalizado </span>", suspended: "<span class='label label-danger'> Suspendido </span>" };
    statusContainer.replaceWith(statusses[status]);
  }

  function addFixedBusinessMarker(map, marker, doNotOpenInfoWindow) {
    var m = new google.maps.Marker({
      map: map,
      position: marker.position,
      title: marker.title,
      animation: google.maps.Animation.DROP,
      icon: '/pizza_business.png',
      draggable: false
    });
    createContentWindow(map, m, m.title, doNotOpenInfoWindow);
    m.addListener('click', handleMarkerClick);
    return m;
  }

  function handleMarkerClick() {
    this.get('infoWindow').open(this.getMap(), this);
  }

  function updatePositions(positionUrl, map) {
    var currentPosition;
    $.ajax({
      url: $('[data-url]').data('url'),
      type: 'GET',
      dataType: 'json',
      async: false,
      success: function (data) {
        if ((data != undefined) && data.length > 1) {
   //       currentPosition = data[data.length - 1].position;
          // load markers in the map only if the position changed
          if (lastPositionChange(currentPosition, lastPosition)) {
            drawTrace(data, map);
            //lastPosition = data[data.length - 1].position
          }

        }
      }
    });
  }

  function updateFixedMarkers(url, businessMarker, map, pathUrl) {
    var currentPosition;
    $.ajax({
      url: url,
      type: 'GET',
      dataType: 'json',
      async: false,
      success: function (data) {
        var bounds = map.get('bounds') || new google.maps.LatLngBounds();
        data.forEach(function(updatedMarker, i) {
          if (updatedMarker.status != fixedMarkers[i].status) {
            fixedMarkers = data;
            addedMarkers[updatedMarker.id].setMap(null);
            delete addedMarkers[updatedMarker.id];
            var m = addFixedMarker(map, updatedMarker, true);
            //bounds.extend(m.getPosition());
            // reload recommended path if some order has been canceled
            if (updatedMarker.status == "canceled") {
              if (polyline != undefined) {
                polyline.setMap(null);
              }
              loadRecommendedPath(map, pathUrl);
            }
          }
        });
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
    polyline = new google.maps.Polyline({
      path: path,
      strokeColor: '#68FF33',
      strokeOpacity: 0.8,
      strokeWeight: 3,
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
    var businessMarker = target.data('business-marker');
    var pathUrl = target.data('recommended-path-url');
    var markersUrl = target.data('markers-url') || target.data('marker-url');
    var positionUrl = target.data('url');
    return {
      init: function() {
        var map = new google.maps.Map(canvas.get(0), {
          center: defaultMapCenter,
          zoom: defaultZoom,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        map.setCenter(new google.maps.LatLng(-34.913283, -57.951501));
        //Load orders delivery position markers
        fixedMarkers = target.data('orders-positions-markers');
        loadMarkers(fixedMarkers, businessMarker, map);
        // Load recommended path
        loadRecommendedPath(map, pathUrl);
        // Update information in interval
        window.setInterval(function(){
          //update orders delivery position markers
          updateFixedMarkers(markersUrl, businessMarker, map, pathUrl);
          // Update traces every 5 seconds
          updatePositions(positionUrl, map);
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

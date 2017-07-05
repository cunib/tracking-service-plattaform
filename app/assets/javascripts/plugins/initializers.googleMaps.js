(function($) {
  var mapInitializers = [];
  var path = [];
  var defaultZoom = 16;
  var lastPosition;
  var polyline;
  var marker;
  var defaultMapCenter = { lat: -34.913283, lng: -57.951501 };
  var unintentialSubmitBlocker = 'onkeypress="if (event.keyCode === 13) { event.preventDefault(); return false; }"';
  var infoWindowContentTemplate = '<div class="window-info">' +
                                  '</div>';
  var mapContainerTemplate = '<div class="map-container"><div class="map-canvas" style="width:800px; height:400px"></div></div>';

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
      $('<strong/>').text(" en " + ubication).appendTo(infoWindowContent)
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
      icon: '',
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
      content.forEach(function(project) {
        $('<p/>').text("* " + project).appendTo(infoWindowContent)
      });
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
      position: JSON.parse(marker.position),
      title: marker.title,
      animation: google.maps.Animation.DROP,
      icon: 'https://maps.google.com/mapfiles/kml/shapes/schools_maps.png',
      draggable: false
    });
    createContentWindow(map, m, marker.projects, doNotOpenInfoWindow);
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
    } catch(e) {
      if (window.console && console.error) {
        console.error(e);
      }
    }
  }

  function createMapInitializer(target, container) {
    var canvas = container.find('.map-canvas');
    var markersList = container.find('.map-markers-list');
    var markers = [];

    return {
      init: function() {
        var map = new google.maps.Map(canvas.get(0), {
          center: defaultMapCenter,
          zoom: defaultZoom,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        // Update traces every 5 seconds
        window.setInterval(function(){
          updatePositions(target.data('url'), map);
        }, 5000);
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

  function academicUnitOptions() {
    options = {}
    return $('.references').data('academic-units').sort(function(a,b){ return a.id - b.id });
  }

  function referenceList(container, subjectAreaOptions, academicUnitOptions) {
    var $container = $(container);
    $('<div/>').addClass('block col-10 ref-title').text("Puntos fijos").appendTo($container);
    var  wrapper = $('<div/>')
      .addClass('block col-3 reference-wrapper image-wrapper')
      .appendTo($container);
    $('<img class="home-ref">')
      .attr('src', 'https://maps.google.com/mapfiles/kml/shapes/schools_maps.png')
      .appendTo(wrapper);
        var span = $('<span/>').attr('title', "Centros Comunitarios de Extensión").appendTo(wrapper);
        $('<div/>').addClass('reference-text').text("Centros Comunitarios de Extensión").appendTo(span);
    $('<div/>').addClass('block col-10 ref-title').text("Áreas temáticas").appendTo($container);
    $.each(subjectAreaOptions, function(k, v) {
      if(k != "") {
        var  wrapper = $('<div/>')
          .addClass('block col-2 reference-wrapper')
          .appendTo($container);
        $('<div/>')
          .addClass('circle')
          .css("background-color", "#" + colors[parseInt(k)-1])
          .appendTo(wrapper);
        var span = $('<span/>').attr('title', v).appendTo(wrapper);
        $('<div/>').addClass('reference-text').text(v).appendTo(span);
      }
    });
    $('<div/>').addClass('block col-10 ref-title').text("Unidades Académicas").appendTo($container);
    $.each(academicUnitOptions, function(index, object) {
        var  wrapper = $('<div/>')
          .addClass('block col-2 reference-wrapper')
          .appendTo($container);
        $('<div/>')
          .addClass('ref')
          .text(object.id)
          .appendTo(wrapper)
        var span = $('<span/>').attr('title', object.attributes.name).appendTo(wrapper);
        $('<div/>').addClass('reference-text')
          .text(object.attributes.name)
          .appendTo(span);
    });
    $('<div/>')
      .addClass('block col-12 footer-text')
      .text(FOOTER_TEXT)
      .appendTo($container);
  }

  function checkProjectCallType(url, projectCallId) {
    var $filterSubjectArea = $('#filter_subject_area_id');
    $.ajax({
      url: url,
      type: 'POST',
      dataType: 'json',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: { project_call_id: projectCallId },
      success: function (data) {
        if (data.project_call_type == 'specific') {
          $filterSubjectArea.hide();
        }
        else {
          $filterSubjectArea.show()
        }
      }
    }); 
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
    $(document.body).append('<script async defer src="//maps.googleapis.com/maps/api/js?signed_in=true&libraries=places&key=' + apiKey + '&callback=initializeGoogleMaps">');
  }

  Initializers.register('google-maps', initializer, condition);
}(jQuery));

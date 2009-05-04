// Using Jquery
var map;
var poly;
var icon_url = "/images/map/markers/";
var MAP_DIV = "map";

function load_route() {

    //$('#zoom_map_link').unbind().click(change_map_zoom)

    createMap(MAP_DIV, 39.774769, -98.085937, 4);

    jQuery("#"+MAP_DIV).ready(function() {
        loadPolyline("route_encoded_points", "#3355ff", 3, .9, "route_lat", "route_lng");
    });

    GEvent.bind(poly, "lineupdated", this, function() {
        polylineUpdated("route_distance", "toolbar_distance" ,"route_distance_unit", "route_loops", "toggleMarkers"
            , "route_lat", "route_lng");
    });

    jQuery("#route_distance_unit").change(function(){
        polylineUpdated("route_distance", "toolbar_distance", "route_distance_unit", "route_loops", "toggleMarkers"
            , "route_lat", "route_lng");
    });

    jQuery("#route_loops").change(function(){
        polylineUpdated("route_distance", "toolbar_distance", "route_distance_unit", "route_loops", "toggleMarkers"
            , "route_lat", "route_lng");
    });

    jQuery("#toggleMarkers").toggle(function(){
        jQuery(this).html("on");
        drawDistanceMarkers( jQuery("#route_distance_unit").val(), "route_loops");
    },function(){
        jQuery(this).html("off");
        removeDistanceMarkers();
    });

    jQuery("#toggleDrawLine").mousedown(function () {
        if (jQuery("#toggleDrawLine").html() == "on") {
            jQuery("#toggleDrawLine").html("off");
            poly.disableEditing();
        } else {
            jQuery("#toggleDrawLine").html("on");
            poly.enableDrawing();
        }
    });

    jQuery("#toggleUnit").toggle(function(){
        jQuery(this).html("mi");
        jQuery("#route_distance_unit").val("mi")
        polylineUpdated("route_distance", "toolbar_distance", "route_distance_unit", "route_loops", "toggleMarkers"
            , "route_lat", "route_lng");
    },function(){
        jQuery(this).html("km");
        jQuery("#route_distance_unit").val("km")
        polylineUpdated("route_distance", "toolbar_distance", "route_distance_unit", "route_loops", "toggleMarkers"
            , "route_lat", "route_lng");
    });

    jQuery("#toggleMapType").toggle(
        function () {
            jQuery(this).html("sat");
            map.setMapType(G_SATELLITE_MAP);
        },
        function () {
            jQuery(this).html("hybrid");
            map.setMapType(G_HYBRID_MAP);

        },
        function () {
            jQuery(this).html("rel");
            map.setMapType(G_PHYSICAL_MAP);
        },
        function () {
            jQuery(this).html("normal");
            map.setMapType(G_NORMAL_MAP);
        }
        );
}

function createMap(mapId, lat, lng, z) {
    if (GBrowserIsCompatible()) {
        map = new GMap2(document.getElementById(mapId))
        map.addControl(new GLargeMapControl3D());
        map.enableScrollWheelZoom();
        map.disableDoubleClickZoom();
        //map.enableGoogleBar();

        var latlng = new google.maps.LatLng(lat, lng);
        /*if (google.loader.ClientLocation) {
            latlng = new google.maps.LatLng(google.loader.ClientLocation.latitude, google.loader.ClientLocation
                .longitude);
            z = 10;
        }*/

        map.setCenter(latlng, z);
    }
}

function loadPolyline(pointsId, color, weight, opacity, latId, lngId) {
    if(jQuery("#"+pointsId).val() == "") {
        poly = new GPolyline([], color, weight, opacity);
    } else {
        poly = new GPolyline.fromEncoded({
            color: color,
            weight: weight,
            opacity: opacity,
            points: jQuery("#"+pointsId).val().replace(/\\\\/g,'\\'),
            levels: "3",
            zoomFactor: 2,
            numLevels: 18
        });
        zoomToPolyline();
        showStartIconMarker(latId, lngId);
    }
    map.addOverlay(poly);

    poly.enableDrawing();
    poly.enableEditing({
        onEvent: "mouseover"
    });
    poly.disableEditing({
        onEvent: "mouseout"
    });

    GEvent.addListener(map, "dblclick", function() {
        poly.enableDrawing();
        jQuery("#toggleDrawLine").html("on");
    });

    // If user press in a poly vertex, we delete it
    GEvent.addListener(poly, "click", function(latlng, index) {
        if (typeof index == "number") {
            poly.deleteVertex(index);
        }
    });

    GEvent.addListener(poly, "endline", function() {
        encodePolyline(pointsId);
        zoomToPolyline();
        jQuery("#toggleDrawLine").html("off");
    });
	
    GEvent.addListener(poly, "lineupdated", function() {
        encodePolyline(pointsId);
    });
}

function showStartIconMarker (latId, lngId) {
    if( (firstPoint == "") || (firstPoint.lat() != poly.getVertex(0).lat()) && (firstPoint.lng() != poly
        .getVertex(0).lng()) ) {
        firstPoint = poly.getVertex(0);
        if (firstPointMarker != "") {
            map.removeOverlay(firstPointMarker);
        }
        var icon = new GIcon();
        icon.image = icon_url + "mrkr_green.png";
        icon.shadow= icon_url + "mrkr_shadow.png";
        icon.iconSize = new GSize(12, 20);
        icon.shadowSize = new GSize(22, 20);
        icon.iconAnchor = new GPoint(6, 20);
        firstPointMarker = new GMarker(firstPoint, icon);
        map.addOverlay(firstPointMarker);

        var fp_lat = firstPoint.lat()
        var fp_lng = firstPoint.lng()
        jQuery("#"+latId).val(fp_lat);
        jQuery("#"+lngId).val(fp_lng);
    }
}

function zoomToPolyline() {
    if (poly && poly.getVertexCount() > 0) {
        var bounds = poly.getBounds();
        map.setCenter(bounds.getCenter());
        map.setZoom(map.getBoundsZoomLevel(bounds));
    }
}

function getPolylineDistance() {
    return poly.getLength();
}

// Update the polyline distance in the form
function polylineUpdated(distanceId, toolbarDistanceId, unitId, loopsId, markers, latId, lngId) {
    var len = getPolylineDistance();
    var unit = jQuery("#"+unitId).val();
    var loops = jQuery("#"+loopsId).val();
    var draw = jQuery("#"+draw).val();
    var distance = (unit == "km") ? ((len/1000) * loops).toFixed(3) : ((len/1609.344) * loops).toFixed(3
        );
    jQuery("#"+distanceId).val(distance);
    jQuery("#"+toolbarDistanceId).html(distance);
    jQuery("#"+markers).html() == "on" ? drawDistanceMarkers(unitId, loopsId) : removeDistanceMarkers();
    showStartIconMarker(latId, lngId);
}

// Draw distance markers on the line
function drawDistanceMarkers(unitVal, loopsId) {
    removeDistanceMarkers();

    var distance = getPolylineDistance();
    var total_distance = distance * $("#"+loopsId).val();
    var step = (unitVal == "km" || unitVal == "m") ? 1000 : 1609.344;

    for (var i = step; i < total_distance; i += step) {
        // route could be more than one loop
        var d = (i / distance)|0;
        var p = (i / distance) - d;
        if ((d == 0) || ((d % 2) == 0)) {
            var x = (distance * p);
        } else {
            var x = distance - (distance * p
                );
        }
        var point = getPointAtDistance(x);
        if (point) {
            var iconOptions = {};
            iconOptions.width = 14;
            iconOptions.height = 14;
            iconOptions.primaryColor = "#FF0000";
            iconOptions.label = (i/step).toFixed(0);
            iconOptions.labelSize = 0;
            iconOptions.labelColor = "#FFFFFF";
            iconOptions.shape = "circle";
            var icon = MapIconMaker.createFlatIcon(iconOptions);
            var marker = new GMarker(point, {
                icon: icon
            });
            map.addOverlay(marker);
            distanceMarkers.push(marker);
        }
    }
}

// Clear distance markers
function removeDistanceMarkers () {
    for(var i = 0; i < distanceMarkers.length; ++i) {
        map.removeOverlay(distanceMarkers[i]);
    }
    distanceMarkers = [];
}

// Return point at distance passed as parameter
function getPointAtDistance (metres) {
    if (metres == 0) return poly.getVertex(0);
    if (metres < 0) return null;
    var dist = 0;
    var olddist = 0;
    for (var i = 1; (i < poly.getVertexCount() && dist < metres); i++) {
        olddist = dist;
        dist += poly.getVertex(i).distanceFrom(poly.getVertex(i-1));
    }
    if (dist < metres) {
        return null;
    }
    var p1 = poly.getVertex(i-2);
    var p2 = poly.getVertex(i-1);
    var m = (metres-olddist)/(dist-olddist);
    return new GLatLng(p1.lat() + (p2.lat()-p1.lat())*m, p1.lng() + (p2.lng()-p1.lng())*m);
}

// Encode polyline
function encodePolyline(pointsId) {
    var i, dlat, dlng;
    var plat = 0;
    var plng = 0;
    var encoded_points = "";
    for(i = 0; i < poly.getVertexCount(); i++) {
        var point = poly.getVertex(i);
        var lat = point.lat();
        var lng = point.lng();
        var late5 = Math.floor(lat * 1e5);
        var lnge5 = Math.floor(lng * 1e5);
        dlat = late5 - plat;
        dlng = lnge5 - plng;
        plat = late5;
        plng = lnge5;
        encoded_points += encodeSignedNumber(dlat) + encodeSignedNumber(dlng);
    }
    jQuery("#"+pointsId).val(encoded_points);
}

function encodeSignedNumber(num) {
    var sgn_num = num << 1;
    if (num < 0) {
        sgn_num = ~(sgn_num);
    }
    return(encodeNumber(sgn_num));
}

function encodeNumber(num) {
    var encodeString = "";
    var nextValue, finalValue;
    while (num >= 0x20) {
        nextValue = (0x20 | (num & 0x1f)) + 63;
        encodeString += (String.fromCharCode(nextValue));
        num >>= 5;
    }
    finalValue = num + 63;
    encodeString += (String.fromCharCode(finalValue));
    return encodeString;
}

/*@todo jmonzon to make the drawing google map bigger, so that drawing on it will be more confortable
. Do a find in project by 'change_map_zoom' appearances
function change_map_zoom(){

            var csz = tb_getPageSize();
            var TB_WIDTH = csz[0]-40; //defaults to 650 if no paramaters were added to URL
			var TB_HEIGHT = csz[1]-40; //defaults to 440 if no paramaters were added to URL
            
			var ajaxContentW = TB_WIDTH - 30;
			var ajaxContentH = TB_HEIGHT - 45;

           var aCnt = $('#TB_ajaxContent');
           var tbW = $('#TB_window');
           tbW.height(TB_HEIGHT);
           tbW.width(TB_WIDTH);
           tbW.css('margin-left',-(TB_WIDTH>>1));
           aCnt.height(ajaxContentH);
           aCnt.width(ajaxContentW);
           var map_sourrond = $('#google_map');
            map_sourrond.height(Math.max(ajaxContentH-150,300));
           map.checkResize();
}
*/
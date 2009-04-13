(function($) {
    $.fn.buildMap = function(gpsData) {
    	if (!this.length || !gpsData.length) {
    		return;
    	}
    	$(this).append('<div id="buildMap-map"></div>\
                        <div id="buildMap-slider">\
                    		<div class="ui-slider-handle" id="buildMap-slider-handle"></div>\
                    	</div>\
                    <span class="small quiet"><a href="#" id="buildMap-shake-slider-handle">Drag slider</a> to move along trail.</span>\
                    <div id="buildMap-elevation"></div>\
                    <p class="quiet center">Elevation (feet/miles)</p>');
        
        /*var map = new GMap2(document.getElementById('buildMap-map'));
        var points = mapGPS(map, gpsData);

        //setup marker
        var tinyIcon = new GIcon();
        tinyIcon.image = "http://labs.google.com/ridefinder/images/mm_20_red.png";
        tinyIcon.shadow = "http://labs.google.com/ridefinder/images/mm_20_shadow.png";
        tinyIcon.iconSize = new GSize(12, 20);
        tinyIcon.shadowSize = new GSize(22, 20);
        tinyIcon.iconAnchor = new GPoint(6, 20);
        tinyIcon.infoWindowAnchor = new GPoint(5, 1);
        var marker = new GMarker(points[0], { icon:tinyIcon });

        //add marker to map
        map.addOverlay(marker);*/

        //build elevation graph
        var elevData = [];
        for (var i=0; i < gpsData.length; i++) {
            elevData.push([gpsData[i][3]/5280, gpsData[i][2]]);
        };
        var lineData = {
            label: "Line",
            data: elevData,
            lines: { show: true, fill: true },
            color:'#7d7ee8'
        };
        var pointData = {
            label: "Point",
            data: [elevData[0], elevData[0]], //needs at least 2 points
            points: { show: true, radius: 5, fill: true, fillColor: '#ff3f4f' },
            color:'#000'
        };
        var elevGraph = $.plot($("#buildMap-elevation"),
            [ lineData ],
            {
                grid: {},
                legend: {show: false}
                //xaxis: { tickFormatter: function(val,axis){return '';} }
            }
        );
        /*updateHtml(gpsData[0]);*/

        /*$('#buildMap-slider').slider({
            max: gpsData.length-1,
            slide:function(e,ui){
                marker.setPoint(points[ui.value]);
                pointData['data'] = [elevData[ui.value], elevData[ui.value]];
                elevGraph.setData([ lineData, pointData ]);
                elevGraph.draw();
                updateHtml(gpsData[ui.value]);
            }
        });
        $('#buildMap-shake-slider-handle').click(function(){
           $('#buildMap-slider-handle').effect('shake');
           return false;
        });*/

        /*$('input[name=map-type]').click(function(){
           map.setMapType(eval($(this).val()));
           $(this).parents('.rollup').slideUp();
        });*/
    };
    function updateHtml(gpsPoint) {
        $('#buildMap-pt').text(round(gpsPoint[0],6) + ', ' + round(gpsPoint[1],6));
        $('#buildMap-elev').text(round(gpsPoint[2],0));
        $('#buildMap-dist').text(round(gpsPoint[3]/5280,2));
    };
    function round(num, points) {
        if (num)
            var multiplier = Math.pow(10, points);
        else
            var multiplier = 1;
        return Math.round(num*multiplier) / multiplier;
    };
})(jQuery);
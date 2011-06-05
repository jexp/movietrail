OpenLayers.Feature.Vector.style['default']['fillColor'] = '#f60';
OpenLayers.Feature.Vector.style['default']['pointRadius'] = '10';
OpenLayers.Feature.Vector.style['default']['strokeColor'] = '#f60';
OpenLayers.Feature.Vector.style['default']['strokeWidth'] = '1';
var animation, animationIndex = 0,
items = $(".stream-item"),

// map
var map = new OpenLayers.Map("map", { controls: []}),
osm = new OpenLayers.Layer.OSM("OSM"),
places = null,
layer = new OpenLayers.Layer.Vector();
map.addLayer(osm);	
map.setBaseLayer(osm);
map.zoomTo(1);
map.addLayer(layer);
new OpenLayers.Request.GET({
	url: "../places.json",
	success: function(response) {
		places = JSON.parse(response.responseText);
		startAnimation();
	}
});

// select element
var selectedElement = null, offsetTop = 0;
var showItem = function(ele) {
	ele.removeClass('night');
	var place = ele.find('.place').text().trim();
	//clearInterval(animation);
	if ('' != place) {
		place = places[place];
		layer.removeAllFeatures();
		var point = new OpenLayers.LonLat(place.latitude, place.longitude).transform(
			new OpenLayers.Projection("EPSG:4326"),
			map.getProjectionObject()
		);
		point = new OpenLayers.Geometry.Point(point.lon, point.lat);
		feature = new OpenLayers.Feature.Vector(point);
		layer.addFeatures([feature]);
	}
	$("#infoboard .info-item").html(ele);
	$("#screenshot-image").attr("src", "/img/james-bond-007-goldfinger/" + Math.floor(ele[0].id / 10) +".jpg");
}
$(".stream-item").click(function() {
	if (null != selectedElement){
		selectedElement.removeClass('selected');
	}
	selectedElement = $(this);
	showItem(selectedElement.clone());
	selectedElement.addClass('selected');
	offsetTop = selectedElement[0].offsetTop - 300;
	window.scrollTo(0, offsetTop);
});


// animation
var startAnimation = function() {
	animation = setInterval(function() {
		$(items[animationIndex]).trigger('click');
		if (!items[animationIndex + 1]) {
			clearInterval(animation);
		}
		animationIndex++;
	}, 1000);
}

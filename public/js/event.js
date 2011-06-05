var selectedElement = null, offsetTop = 0;
var showItem = function(ele) {
	ele.removeClass('night');
/*
	var place = $('.place');
	if (0 < place.lenght) {
		console.log(place);
	}
*/
	$("#infoboard .info-item").html(ele);
}
$(".stream-item").click(function() {
	if (null != selectedElement){
		selectedElement.removeClass('selected');
	}
	selectedElement = $(this);
	showItem($(this).clone());
	selectedElement.addClass('selected');
	offsetTop = selectedElement[0].offsetTop - 300;
	window.scrollTo(0, offsetTop);
});

// animation
var items = $(".stream-item"),
i = 0,
animation = setInterval(function() {
	$(items[i]).trigger('click');
	if (!items[i + 1]) {
		clearInterval(animation);
	}
	i++;
}, 100);

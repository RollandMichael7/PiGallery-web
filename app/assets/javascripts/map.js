var lastOpenWindow = null;
var map = null;

function initMap() {
	let mapElem = $('#map');
	let isMobile = mapElem.hasClass("g-map-mobile");

	map = new google.maps.Map(mapElem[0], {
		center: { lat: 39.877742, lng: -93.380979 },
		zoom: isMobile ? 3 : 5,
		disableDefaultUI: true,
		fullscreenControl: true,
	});
}

function initPins() {
	$.ajax({
		url: `/map/coordinates`,
		type: 'GET',
		success: function(coords) {
			coords.forEach(coord => {
				let content = `<div class="g-map-pin-content">` +
					`<a href="/locations/${coord.id}" style="color: inherit">` +
					`<h5 class="g-map-pin-title"> ${coord.name} </h5>` +
					`<img class="g-map-pin-img" src=${coord.image}>` +
					`</a>` +
					`</div>`;

				let infoWindow = new google.maps.InfoWindow({
					content: content,
					ariaLabel: coord.name,
				});

				let marker = new google.maps.Marker({
					position: {
						lat: parseFloat(coord.latitude),
						lng: parseFloat(coord.longitude)
					},
					map,
					title: coord.name,
				});

				marker.addListener("click", () => {
					if (lastOpenWindow) {
						lastOpenWindow.close();
					}

					infoWindow.open({
						anchor: marker,
						map,
					});
					lastOpenWindow = infoWindow;
				});
			});
		},
		error: function(e1) {
			console.log(e1);
		}
	});
}

$(document).ready(function() {
	initMap();
	initPins();
});


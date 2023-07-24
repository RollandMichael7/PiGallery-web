var lastOpenWindow = null;
var map = null;

function initMap() {
	let mapElem = $('#map');
	let isMobile = mapElem.hasClass("g-map-mobile");

	map = new google.maps.Map(mapElem[0], {
		center: { lat: 39.877742, lng: -93.380979 },
		zoom: isMobile ? 3 : 5,
		// display only fullscreen control
		disableDefaultUI: true,
		fullscreenControl: true,
		// allow panning with one finger on mobile
		gestureHandling: "greedy",
	});
}

function initPins() {
	$.ajax({
		url: `/map/coordinates`,
		type: 'GET',
		success: function(coords) {
			coords.forEach(coord => {
				let fromMonth = coord.month_range["from"];
				let toMonth = coord.month_range["to"];

				let monthRange = fromMonth;
				if (toMonth != monthRange) {
					monthRange += ` - ${toMonth}`;
				}

				let content = `<div class="g-map-pin-content">` +
					`<a href="/locations/${coord.id}" style="color: inherit">` +
					`<h5 class="g-map-pin-title"> ${coord.name} </h5>` +
					`<p class="g-map-pin-subtitle fw-light fst-italic text-muted"> ${monthRange} </p>` +
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


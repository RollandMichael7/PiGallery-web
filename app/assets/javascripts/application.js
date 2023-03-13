//= require rails-ujs
//= require jquery
//= require jquery-ui
//= require popper
//= require bootstrap

var didScroll;
var lastScrollTop = 0;
var delta = 5;
var navbarHeight = $('#topbar').outerHeight();

function isMobile() {
	return $('#page-content').hasClass("mobile");
}

function sidebarIsOpen() {
	return $('#sidebar').hasClass("sidebar-open");
}

function hasScrolled() {
	// hide topbar on scroll down, show on scroll up
	var st = $(this).scrollTop();
	if (Math.abs(lastScrollTop - st) <= delta) {
		return;
	}
	if (st > lastScrollTop && st > navbarHeight) {
	  $('#topbar').addClass('topbar-up');
	} else {
	  if(st + $(window).height() < $(document).height()) {
	  	$('#topbar').removeClass('topbar-up');
	  }
	}
	lastScrollTop = st;
}

$(document).ready(function() {	
	// run hasScrolled() and reset didScroll status
	setInterval(function() {
		if (didScroll) {
			hasScrolled();
			didScroll = false;
		}
	}, 250);

	$('.sidebar-toggle').on("click", function() {
		$('#page-bg').toggleClass("gray-bg");
		$('#sidebar').toggleClass("sidebar-open");

		if ($('#sidebar').hasClass("sidebar-open")) {
			scrollLock.disablePageScroll();
			scrollLock.enablePageScroll($('#sidebar'));
		}
		else {
			scrollLock.enablePageScroll();
		}
	});

	$(document).click(function(event) { 
		var $target = $(event.target);
		if (isMobile() && !$target.closest('.sidebar').length && !$target.closest('.topbar').length) {
			$('#page-bg').removeClass("gray-bg");
			$('#sidebar').removeClass("sidebar-open");
			scrollLock.enablePageScroll();
		}
	});

	// on scroll, let the interval function know the user has scrolled
	$(window).scroll(function(event) {
		didScroll = true;
	});

	$('.link-card').on("click", function(e) {
		if (sidebarIsOpen() && isMobile()) {
			return;
		}
		let link = $(this).data("link");
		window.location = link.startsWith("/") ? link : `/${link}`;
		e.stopPropagation();
	});

	$('.rainbow-highlight').on("mouseenter", function() {
		if (sidebarIsOpen() && isMobile()) {
			return;
		}
		r = Math.floor(Math.random() * 255);
		g = Math.floor(Math.random() * 255);
		b = Math.floor(Math.random() * 255);

		$(this).animate({backgroundColor: `rgba(${r},${g},${b},.3)`}, 300);
	});
	$('.rainbow-highlight').on("mouseleave", function() {
		$(this).animate({backgroundColor: ''}, 300);
	});

	$('.show-all-badges').on("click", function(e) {
		$(this).hide();
		var container = $(this).closest('.badge-container');
		var hiddenBadges = container.find('.hidden-badges');
		hiddenBadges.show();
		e.stopPropagation();
	});
});
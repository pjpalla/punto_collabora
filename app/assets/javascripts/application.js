// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree

//= require chartkick
$(function() {
  setTimeout(function(){
    $('.alert').fadeOut(800);
  }, 1000);
  
  var divs = $('div[id^="content-"]').hide(),
    i = 0;

(function cycle() { 
    divs.eq(i).fadeIn(400)
              .delay(2500)
              .fadeOut(400, cycle);

    i = ++i % divs.length; // increment i, 
                           //   and reset to 0 when it equals divs.length
})();
  
});



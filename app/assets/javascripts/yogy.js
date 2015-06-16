// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function resizeimage( index, img ) {
  var contentwidth = $('body').width();
  var img_url = '';
  var is_title = $.inArray( "title", img.classList ) >= 0;

  if ((contentwidth) < '380') {
    if (is_title) {
      img_url = $(img).attr('data-src-small');
    } else {
      img_url = $(img).attr('data-src-xsmall');
    }
  } else {
    if (is_title) {
      img_url = $(img).attr('data-src-normal');
    } else {
      img_url = $(img).attr('data-src-small');
    }
  }
  $(img).attr('src', img_url);
}

function img_lazyload() {
  $.each( $('.yogy_img'), resizeimage );
}

function yogy_index() {
  var contentwidth = $('body').width();
  if ((contentwidth) < '380') {
    $('.yogy_img_cols').addClass('col-xs-4 col-md-3');
  } else {
    $('.yogy_img_cols').addClass('col-sm-6 col-md-4');
  }
}

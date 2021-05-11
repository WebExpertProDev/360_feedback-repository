// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require popper.min
//= require sweetalert
//= require turbolinks
//= require toastr_rails

//= require chartkick
//= require Chart.bundle
//= require highcharts
//= require highcharts-more

//= require fusioncharts
//= require fusioncharts.charts
//= require fusioncharts.widgets
//= require themes/fusioncharts.theme.fint

//= require Chart.min
// require Chart.bundle.min

//= require_tree .

toastr.options = Object.assign({}, toastr.options, {
  "progressBar": true
});

$(document).on("turbolinks:load", function() {
  var table = $('.table-datatable table').DataTable({

  });
  document.addEventListener("turbolinks:before-cache", function() {
    if (table !== null) {
      table.destroy();
      table = null;
    }
  });
  $('select').addClass('form-control');
  $('#locale a').addClass('dropdown-item');
  var trd = $('.colored');
  var trs = $('.colored_tr');
  var colors = {};
  colors["color_1"] = "#ecace9";
  colors["color_2"] = "#bdbcbc";
  colors["color_3"] = "#bfedf1";
  colors["color_4"] = "#e57e84";
  colors["color_5"] = "#f8dbba";
  // for (var a = 0; a < trd.length; a++) {
  for (var i = 0; i < trs.length; i++) {

    $(`table .colored_tr:nth-child(${i}) .colored_1`).each(function() {
      if ($(this).text() != "") {
        $(this).css('background', colors["color_" + i]);
        $(this).closest('.colored_td').prevAll('.colored_td').find('.colored_1').css('background', colors["color_" + i]);
        $(this).text('');
      }
    });
    $(`table .colored_tr:nth-child(${i}) .colored_2`).each(function() {
      if ($(this).text() != "") {
        $(this).css('background', colors["color_" + i]);
        $(this).closest('.colored_td').prevAll('.colored_td').find('.colored_2').css('background', colors["color_" + i]);
        $(this).text('');
      }
    });
  }
  // }

  $('.height-o').each(function() {
    var height1 = $(this).innerHeight();
    $(this).closest('tr').find('.colss').css('height', "calc(" + height1 / 2 + "px");
  });
  $('select').addClass('form-control');
  $('.pagination .page, .pagination .next, .pagination .prev, .pagination .last, .pagination .first').addClass('page-item');
  $('.pagination .page.current, .pagination .page a, .pagination .next a, .pagination .prev a, .pagination .last a, .pagination .first a').addClass('page-link');

  if (window.matchMedia('(min-width: 992px)').matches) {
    $('.leadership-test').each(function() {
      var height_3_1 = $(this).find('.coll3:first-child').innerHeight();
      var height_3_1_h4 = $(this).find('.coll3:first-child h4').innerHeight();
      var height_3_2 = $(this).find('.coll3:last-child').innerHeight();
      var height_3_2_h4 = $(this).find('.coll3:last-child h4').innerHeight();
      var height_6 = $(this).find('.coll6').innerHeight();
      if (height_3_1 > height_3_2) {
        $(this).find('.coll3:last-child').innerHeight(height_3_1);
        $(this).find('.coll3:last-child').removeClass('py-3');
        $(this).find('.coll3:last-child h4').css('padding-top', (height_3_1 - height_3_2_h4) / 2);
        $(this).find('.coll3:last-child h4').css('padding-bottom', (height_3_1 - height_3_2_h4) / 2);
      } else if (height_3_2 > height_3_1) {
        $(this).find('.coll3:first-child').innerHeight(height_3_2);
        $(this).find('.coll3:first-child').removeClass('py-3');
        $(this).find('.coll3:first-child h4').css('padding-top', (height_3_2 - height_3_1_h4) / 2);
        $(this).find('.coll3:first-child h4').css('padding-bottom', (height_3_2 - height_3_1_h4) / 2);
      }
      if (height_3_1 > height_6 || height_3_2 > height_6) {
        $(this).find('.coll3').addClass('border-q');
      } else {
        $(this).find('.coll6').addClass('border-q');
      }
    });
  }
  /*if ($('.questionnaire').val() != 1) {
    $('.statements').hide();
  }
  $('.questionnaire').on('change', function() {
    if ($(this).val() != 1) {
      $('.statements').hide();
      $('.statements textarea').prop('required', false);
      $('.statements textarea').val(null);
    } else {
      $('.statements textarea').prop('required', true);
      $('.statements').show();
    }
  });*/

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('#imagePreview').css('background-image', 'url(' + e.target.result + ')');
        $('#imagePreview').hide();
        $('#imagePreview').fadeIn(650);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
  $("#imageUpload").change(function() {
    readURL(this);
  });
});











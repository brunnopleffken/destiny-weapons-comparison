//= require jquery/dist/jquery.min
//= require bootstrap/dist/js/bootstrap.min
// require jquery_ujs
// require_tree .


$(document).ready(function() {
  $('#search-form').on('submit', function(event) {
    // Get values
    var primaryWeapon = $('#primary-weapon').val();
    var secondaryWeapon = $('#secondary-weapon').val();

    // Don't submit the form in the ordinary way
    event.preventDefault();

    // Redirect
    window.location.href = '/' + primaryWeapon + '/' + secondaryWeapon;
  });
});

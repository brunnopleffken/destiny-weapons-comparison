//= require jquery.min
//= require bootstrap.min
//= require_tree .


$(document).ready(function() {

  /**
   * Initialize Bootstrap components
   */
  $('[data-toggle="tooltip"]').tooltip();


  /**
   * Search form
   */
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

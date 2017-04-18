//= require jquery/dist/jquery.min
//= require bootstrap/dist/js/bootstrap.min
//= require select2/dist/js/select2.full.min
//= require_tree .


$(document).ready(function() {

  /**
   * Initialize Select2
   */

  $('.search-weapon').select2({
    minimumInputLength: 3,
    // escapeMarkup: function (markup) { return markup; },
    templateResult: formatWeaponResult,
    templateSelection: formatWeaponSelection,
    ajax: {
      cache: true,
      dataType: 'json',
      delay: 250,
      url: '/search/' + $('#language').val(),
      data: function(params) {
        return {
          'term': params.term
        }
      },
      processResults: function(data) {
        return {
          results: $.map(data.Response.definitions.items, function(item) {
            return {
              slug: item.itemName,
              name: item.itemName,
              icon: item.icon,
              id: item.hash
            };
          })
        }
      }
    }
  });

  /**
   * Initialize Bootstrap components
   */
  $('[data-toggle="tooltip"]').tooltip();

  /**
   * Change placeholder when changing language
   */
  $('#language').on('change', function() {
    console.log($(this).val());

    switch ($(this).val()) {
      case 'de':
        button = 'Vergleichen';
        break;
      case 'en':
        button = 'Compare';
        break;
      case 'es':
        button = 'Comparar';
        break;
      case 'fr':
        button = 'Comparer';
        break;
      case 'it':
        button = 'Confrontare';
        break;
      case 'jp':
        button = '比べる';
        break;
      case 'pt-br':
        button = 'Comparar';
        break;
      default:
        button = 'Compare';
    }

    $('#compare-button').html(button);
  });


  /**
   * Search form
   */
  $('#search-form').on('submit', function(event) {
    // Get values
    var primaryWeapon = $('#primary-weapon').val();
    var secondaryWeapon = $('#secondary-weapon').val();
    var language = $('#language').val();

    // Don't submit the form in the ordinary way
    event.preventDefault();

    // Redirect
    window.location.href = '/' + primaryWeapon + '/' + secondaryWeapon + '?lang=' + language;
  });
});

function formatWeaponResult(weapon) {
  console.log(weapon);
  if (weapon.loading) return weapon.text;

  var $state = $(
    '<span class="select2_weapon-result">' +
    '<img src="https://www.bungie.net' + weapon.icon + '">' +
    '<strong>' + weapon.name + '</strong>' +
    '</span>'
  );

  return $state;
}

function formatWeaponSelection(weapon) {
  return weapon.name || weapon.text;
}

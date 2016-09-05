//= require jquery/dist/jquery.min
//= require bootstrap/dist/js/bootstrap.min
//= require_tree .


$(document).ready(function() {

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
        first = 'Lerrer Blick';
        second = 'Y-09 Langbogen-Synthese';
        button = 'Vergleichen';
        break;
      case 'en':
        first = '1000-Yard Stare';
        second = 'Y-09 Longbow Synthesis';
        button = 'Compare';
        break;
      case 'es':
        first = 'Mirada Kilométrica';
        second = 'Síntesis de Arco Largo Y-09';
        button = 'Comparar';
        break;
      case 'fr':
        first = 'Vue d\'aigle';
        second = 'Synthèse d\'arc Y-09';
        button = 'Comparer';
        break;
      case 'it':
        first = 'Sguardo Perso';
        second = 'Y-09 Sintesi Arco Lungo';
        button = 'Confrontare';
        break;
      case 'jp':
        first = '1000mの凝視';
        second = 'Y-09 ロングボウ合成';
        button = '比べる';
        break;
      case 'pt-br':
        first = 'Encarada de 1000 Jardas';
        second = 'Síntese do Arco Longo Y-09';
        button = 'Comparar';
        break;
      default:
        first = '1000-Yard Stare';
        second = 'Y-09 Longbow Synthesis';
        button = 'Compare';
    }

    $('#primary-weapon').attr('placeholder', first);
    $('#secondary-weapon').attr('placeholder', second);
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

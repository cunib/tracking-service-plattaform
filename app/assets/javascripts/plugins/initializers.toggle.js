(function($) {

  function condition() {
    return $('.toggle-control:not(.toggle-init)').length > 0;
  }

  function hideList() {
    $('.left-column').animate({ width:'toggle' }, { duration: 350, complete: function() {
      $('.right-column').toggleClass('col-7 col-10');
    }});
    $(this).toggleClass('toggle-btn-hide toggle-btn-show').html("\&gt\;");
  }

  function showList() {
    $('.right-column').toggleClass('col-7 col-10');
    $('.left-column').animate({ width:'toggle' }, { duration: 350 });
    $(this).toggleClass('toggle-btn-hide toggle-btn-show').html("\&lt\;");
  }

  function initializer() {
    $('.toggle-control')
      .on('click', '.toggle-btn-show', showList)
      .on('click', '.toggle-btn-hide', hideList)
      .addClass('toggle-init')
  }

  Initializers.register('toggle', initializer, condition);
}(jQuery));

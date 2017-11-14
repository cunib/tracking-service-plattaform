// DatePicker JS initializer
(function($) {
  function initialize() {
    $('input.datetime_picker').datetimepicker({ sideBySide: true, format: 'DD/MM/YYYY HH:mm' });
    $('input.ui-date-picker, .payment-filter .datepicker').datetimepicker({ language: 'es' });
  }

  Initializers.register('datetimepicker', initialize);
}(jQuery));

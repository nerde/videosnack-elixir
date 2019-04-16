import $ from 'jquery';

const formatCents = cents => (cents / 100).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');

$(() => {
  $('.money-input').on('input', ({ target }) => {
    let { value } = target;
    value = value.replace(/\D/g, '');

    if (value.length) {
      value = parseInt(value, 10);

      $(target).val(value ? formatCents(value) : '');
      $(`#${target.id}_cents`).val(value);
    }
  });
});

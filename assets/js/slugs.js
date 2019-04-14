import $ from 'jquery';

$(() => {
  $('input[data-set-slug]').keyup(ev => {
    $($(ev.target).data('set-slug')).val(ev.target.value.toLowerCase().replace(/[^\w0-9]/g, '-'));
  });
});

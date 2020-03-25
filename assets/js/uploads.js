import $ from 'jquery';

$(() => {
  $('#episode_file').on('change', ev => {
    const input = $(ev.target);

    [...ev.target.files].forEach(file => {
      $.post({
        url: input.data('presign-url'),
        data: { name: file.name, size: file.size, type: file.type },
        dataType: 'json',
        beforeSend: xhr => xhr.setRequestHeader('X-CSRF-Token', input.data('token')),
      });
    });
  });
});

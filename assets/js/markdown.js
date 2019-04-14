import $ from 'jquery';
import SimpleMDE from 'simplemde';

$(() => {
  $('.markdown-editor').each(() => new SimpleMDE({ element: this }));
})

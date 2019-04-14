import $ from 'jquery';

$(() => {
  const distributionRadio = $('.distribution-radio');
  distributionRadio.click(ev => {
    const price = $($(ev.target).data('show-price'));
    if (ev.target.value === 'free') {
      price.slideUp();
    } else {
      price.slideDown();
    }
  });

  const price = $(distributionRadio.data('show-price'));
  if (distributionRadio.val() === 'free') {
    price.hide();
  } else {
    price.show();
  }
});

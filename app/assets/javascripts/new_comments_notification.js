$(function () {
  $('#info-bar').hide();
  $('#new-comments-indicator').click(function () {
    $('#info-bar').slideToggle('fast');
    return false;
  });
});

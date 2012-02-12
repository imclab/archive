$(function() {
  function text_counter(input, target) {
    var max = input.attr("maxlength");
    input.focus(function() {
      target.removeClass('invisible');
      var left = max - this.value.length;
      target.text("You have " + left + " characters remaining");
    });
    input.blur(function() {
      target.addClass('invisible');
    });
    input.keyup(function() {
      var left = max - this.value.length;
      target.text("You have " + left + " characters remaining");
    });
  };
  text_counter($("#tag_name"), $("#tag-input-help"));
  text_counter($("#user_name"), $("#user-name-input-help"));
  text_counter($("#user_password"), $("#user-password-input-help"));
});

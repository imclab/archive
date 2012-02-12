$(function() {
  // Writes to 'target' how many chars are left to type in 'input'
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

  // Toggles all checkboxes on the current page
  function toggleCheckboxes() {
    var checkboxes = $("input[type=checkbox]");
    checkboxes.each(function() {
      this.checked = !this.checked; 
    });
  };
      
  // Sessions#new - Bind the toggleCheckboxes function to the
  // "Check-all" checkbox.  
  $("#check-all").change(function() {
    this.checked = !this.checked;
    toggleCheckboxes();
  });
  
  // Songs#show
  text_counter($("#tag_name"), $("#tag-input-help"));
  // When a new tag is submitted, clear and unfocus the input
  $("#new_tag").live("ajax:beforeSend", function(event,xhr,status){
    $('#tag_name').val('');
    $('#tag_name').blur();
  });

  // Users#new and Users#edit
  text_counter($("#user_name"), $("#user-name-input-help"));
  text_counter($("#user_password"), $("#user-password-input-help"));
});

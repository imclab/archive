$(function() {
  //
  // FUNCTIONS
  //

  // text_counter(input, target):
  // Writes to 'target' how many chars are left to type in 'input'
  function text_counter(input, target) {
    var max = input.attr("maxlength");
    var min = input.attr("data-minlength");
    input.focus(function() {
      target.removeClass('invisible');
      $(this).parents().eq(1).addClass('active');
      var left = max - this.value.length;
      target.text("You have " + left + " characters remaining");
    });
    input.blur(function() {
      if (min && this.value.length < min) {
        target.text("Needs to be at least " + min + " characters");
        target.addClass('input-error');
      } else {
        target.removeClass('input-error');
        target.addClass('invisible');
      };
      $(this).parents().eq(1).removeClass('active');
    });
    input.keyup(function() {
      var left = max - this.value.length;
      target.text("You have " + left + " characters remaining");
    });
  };

  // toggleCheckboxes
  // Toggles all checkboxes on the current page
  function toggleCheckboxes() {
    var checkboxes = $("input[type=checkbox]");
    checkboxes.each(function() {
      this.checked = !this.checked; 
    });
  };
      
  //
  // SETUP 
  //

  // Sessions#new - Bind the toggleCheckboxes function to the
  // "Check-all" checkbox.  
  $("#check-all").change(function() {
    this.checked = !this.checked;
    toggleCheckboxes();
  });
 
  // Songs#show
  // When a new tag is submitted, clear and unfocus the input
  $("#new_tag").live("ajax:beforeSend", function(event,xhr,status){
    $('#tag_name').val('');
    $('#tag_name').blur();
  });

  // Users#new and Users#edit
  var inputs = [
    {'input': '#user_name', 'target': '#name-notification'},
    {'input': '#user_password', 'target': '#password-notification'},
    {'input': '#user_password_confirmation', 'target': '#password-conf-notification'}
  ];

  for (var i = 0; i < inputs.length; i++) {
    var item = inputs[i];
    text_counter($(item.input), $(item.target));
  };
});

$(function() {
  var toggleCheckboxes = function() {
    var checkboxes = $("input[type=checkbox]");
    checkboxes.each(function() {
      this.checked = !this.checked; 
    });
  };
      
  $("#check-all").change(function() {
    this.checked = !this.checked;
    toggleCheckboxes();
  });
});

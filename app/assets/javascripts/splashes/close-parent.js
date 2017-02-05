$(function() {
  $("[data-role='close-parent-trigger'").click(function(){
    event.preventDefault();

    $(this).parent().addClass("closed");
  });
});

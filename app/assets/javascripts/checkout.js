function checkUsername() {
  var element = $(this);
  var container = element.parent("li");
  if(element.val() == "") {
    if(element.prop('required')) {
      container.addClass("error");
    }
  } else {
    checkValidGithubUsername(element.val(), element);
  }
}
$("input#checkout_github_username").blur(checkUsername);

function checkValidGithubUsername(username, element) {
  var container = element.parent("li");
  var url = "https://api.github.com/users/" + username;
  var req = $.ajax({
    url : url,
      dataType : "jsonp",
      success : function(response) {
        if(response.data.message == "Not Found" || response.data.type == "Organization") {
          container.addClass("error");
        } else {
          container.removeClass("error");
        }
      }
  });
}

$('.address-info').hide();
$('.reveal-address').click(function() {
  $(this).hide();
  $('.address-info').show();

  return false;
});

window.onload = function(){
  var $timer = $("[data-role='sale-timer']");
  var targetDate = new Date(2017, 02, 10);

  setInterval(function(){
    setTime(countdown(targetDate));
  }, 1000);

  setTimeout(function(){
    $timer.removeClass("closed");
  }, 1000);

  function setTime(time) {
    $("[data-role='sale-timer-days']").html(time.days);
    $("[data-role='sale-timer-hours']").html(time.hours);
    $("[data-role='sale-timer-minutes']").html(time.minutes);
    $("[data-role='sale-timer-seconds']").html(time.seconds);
  }
};

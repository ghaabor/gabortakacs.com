$(function(){
  $("p#name").css("visibility", "visible").animate(
    {opacity: 1.0}, 2000, function(){
      $("span.name").typed({
        strings: ["g^200ab^150or_^100taka^250cs"],
        typeSpeed: 150,
        startDelay: 1000,
        cursorChar: "_", 
        callback: function(){
          var timeOffset = 500;
          $(".social-link").each(function(){
            $(this).delay(timeOffset).css("visibility", "visible").animate(
              {opacity: 1.0}, 500
              );
            timeOffset += 750;
          });
        }
      });
    });
  $("#mail").click(
    function() {
      var username, domain, subject, mailto;

      // Decode email address
      username = $(this).attr("data-username").split("").reverse().join("")
      domain = $(this).attr("data-domain").split("").reverse().join("")
      mailto = username + "@" + domain
      // Add subject
      subject = $(this).attr("data-subject")
      if (subject.length > 0) {
        mailto += "?subject="+subject
      }

      window.location.href = "mailto:" + mailto;
    })
});

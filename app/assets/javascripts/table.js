$("[data-link]").click(function(e) {
  window.location = $(this).data("link");
});

$(function(){
  $('a[rel~="tooltip"]').tooltip();
})

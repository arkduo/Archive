$("[data-link]").click(function(e) {
  window.location = $(this).data("link");
});

jQuery(function($) {
  $('#sort').tablesorter({
    sortList: [[3,0]]
  });
});

$("[data-link]").click(function(e) {
  window.location = $(this).data("link");
});

jQuery(function($) {
  $('#sort').tablesorter({
    sortList: [[3,0]]
  });
});
/*
!function(){var t="thumbfit";$[t]=function(i,n){var e={pluginName:t,width:100,height:100},s=this;s.settings={};var a=$(i),i=i;s.init=function(){s.settings=$.extend({},e,n),s.items=n.items,a.each(function(t,i){$(i).addClass("background-fix"),$(i).css({"background-image":"url("+$("img",i).attr("src")+")",width:s.settings.width,height:s.settings.height,"background-position":"center center","background-repeat":"no-repeat","background-size":"cover"}),$("img",i).css({opacity:0})})},s.init()},$.fn[t]=function(i){return i||(i={}),i.items=[],this.each(function(n){if(i.id=n,i.items.push($(this)),void 0==$(this).data(t)){var e=new $[t](this,i);$(this).data(t,e)}})}}(jQuery);

$('div.thumb', 'div.pin').thumbfit();
*/

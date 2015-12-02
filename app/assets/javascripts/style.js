$(function() {
  var $mybook     = $('#mybook');
  var $bttn_next    = $('#next_page_button');
  var $bttn_prev    = $('#prev_page_button');
  var $loading    = $('#loading');
  var $mybook_images  = $mybook.find('img');
  var cnt_images    = $mybook_images.length;
  var loaded      = 0;
  
  //右開の場合とか。
  var startPage = $(".b-load div").size();

  //preload all the images in the book,
  //and then call the booklet plugin

  $mybook_images.each(function(){
    var $img  = $(this);
    var source  = $img.attr('src');
    $('<img/>').load(function(){
      ++loaded;
      if(loaded == cnt_images % 10){
        $loading.hide();
        $bttn_next.show();
        $bttn_prev.show();
        $mybook.show().booklet({
          name:               null,
          width:              880,
          height:             640,
          speed:              300,
          direction:          'RTL',
          startingPage:       startPage,
          easing:             'easeInOutQuad',
          easeIn:             'easeInQuad',
          easeOut:            'easeOutQuad',

          closed:             false,
          closedFrontTitle:   null,
          closedFrontChapter: null,
          closedBackTitle:    null,
          closedBackChapter:  null,
          covers:             false,

          pagePadding:        0,
          pageNumbers:        false,

          hovers:             false,
          overlays:           false,
          tabs:               false,
          tabWidth:           60,
          tabHeight:          20,
          arrows:             false,
          cursor:             'pointer',

          hash:               false,
          keyboard:           true,
          next:               $bttn_next,
          prev:               $bttn_prev,
          auto:               false,
          delay:              3000,

          menu:               null,
          pageSelector:       false,
          chapterSelector:    true,

          shadows:            true,
          shadowTopFwdWidth:  166,
          shadowTopBackWidth: 166,
          shadowBtmWidth:     50,

          before:             function(){},
          after:              function(){}
        });
        // Cufon.refresh();
      }
    }).attr('src',source);
  });
      
  $("a.toppage").attr('data-page',startPage);
  //ページネーション          
  $("a.gopage").click(function(){
    var pageNo = $(this).attr('data-page');
    pageNo-=0;//マイナスゼロをして数値型に変換
    $mybook.booklet(pageNo);
  });

  $('#cover').click(function(e){
    var newPageHtml = "<div></div>";
    e.preventDefault();
    if($(this).attr('auth') == "true"){
      $(this).text("表紙:なし");
      $(this).attr('auth', "false");
      $mybook.booklet("remove", "start");
    }else{
      $(this).text("表紙:あり");
      $(this).attr('auth', "true");
      $mybook.booklet("add", "start", newPageHtml);
    };
  });

  $('#auto').click(function(e){
    e.preventDefault();
    if($(this).attr('auth') == "true"){
      $(this).text("自動:オフ");
      $(this).attr('auth', "false");
      $mybook.booklet("option", "auto", false);
    }else{
      $(this).text("自動:オン");
      $(this).attr('auth', "true");
      $mybook.booklet("option", "auto", true);
    };
  });
  
  $(window).on('load', function(e){
    $('.selectpicker').selectpicker({
      'selectedText': 'cat'
    });
  });

  $('.autopage').on('change', function(e){
    e.preventDefault();
    if($(this).attr('value') == "3000"){
      $mybooklet("option", "auto", true);
    }
  });
});



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

  // 表紙の追加・削除
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
    }
  });

  // 自動ページめくり
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
    }
  });

  // スクロールのロック
  $('#lock').click(function(){
    if($(this).attr('flag') == "true"){
      $(window).on('touchmove.noScroll', function(e){
        e.preventDefault();
        $(this).text("スクロール:禁止");
        $(this).attr('flag', "false");
      });
    }else{
      $(window).off('.noScroll');
      $(this).text("スクロール:可能");
      $(this).attr('flag', "true");
    }
  });
  
  // スワイプ動作の対応
  window.addEventListener("load", function(event) {
    var touchStartX;
    var touchStartY;
    var touchMoveX;
    var touchMoveY;
 
    // 開始時
    window.addEventListener("touchstart", function(event) {
    //event.preventDefault();
    // 座標の取得
    touchStartX = event.touches[0].pageX;
    touchStartY = event.touches[0].pageY;
    }, false);
 
    // 移動時
    window.addEventListener("touchmove", function(event) {
    //event.preventDefault();
    // 座標の取得
    touchMoveX = event.changedTouches[0].pageX;
    touchMoveY = event.changedTouches[0].pageY;
    }, false);
 
    // 終了時
    window.addEventListener("touchend", function(event) {
      /*if (touchStartY > touchMoveY) {
        if (touchStartY > (touchMoveY +50)) {
          window.scrollTo(touchMoveX, touchMoveY);
        }
      } else if (touchStartY < touchMoveY) {
        if ((touchStartY + 50) < touchMoveY) {
          window.scrollTo(touchStartX, touchStartY);
        }
      }*/
      // 移動量の判定
      if (touchStartX > touchMoveX) {
        if (touchStartX > (touchMoveX + 50)) {
          //右から左に指が移動した場合
          $mybook.booklet("next");
        }
      } else if (touchStartX < touchMoveX) {
        if ((touchStartX + 50) < touchMoveX) {
          //左から右に指が移動した場合
          $mybook.booklet("prev");
        }
      }
    }, false);
  }, false);
});



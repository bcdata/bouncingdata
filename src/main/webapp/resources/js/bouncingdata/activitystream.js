function ActivityStream() {

}

ActivityStream.prototype.init = function() {
  var me = this;
  this.streamEnded = false;
  this.streamLoading = false;
  me.$feedTemplate = $('#feed-item-template').template();
  var main = com.bouncingdata.Main;

  com.bouncingdata.Nav.setSelected('page', 'stream');

  $(function() {

    $('#stream .event').each(function() {
      com.bouncingdata.ActivityStream.loadAnalysisByAjax($(this));
    });

    $('.more-feed').click(function() {
      var $lastEvent = $('#stream .event:last');
      if ($lastEvent.length > 0 && !me.streamEnded && !me.streamLoading) {
        me.loadMore($lastEvent.attr('aid'));
      }
    });

    if (!main.jsLoader["stream"]) {
      $(window).scroll(function() {
        if ($('#stream').length > 0 && ($(window).scrollTop() + 80 >= $(document).height() - $(window).height())) {
          if (!me.streamEnded && !me.streamLoading) {
            var $lastEvent = $('#stream .event:last');
            if ($lastEvent.length > 0) {
              me.loadMore($lastEvent.attr('aid'));
            }
          }
        }
      });
    }

    // important! to avoid duplicate events on window object
    main.jsLoader["stream"] = true;
  });
}

/**
 * Loads more recent activity stream.
 * @param lastId the last (oldest) activity id currently in activity stream.
 */
ActivityStream.prototype.loadMore = function(lastId) {
  var me = this;
  $('#stream .feed-loading').show();
  this.streamLoading = true;
  $.ajax({
    url: ctx + '/a/more/' + lastId,
    success: function(result) {
      me.streamLoading = false;
      console.debug("More " + result.length + " feeds loaded!");
      // appending
      if (result.length > 0) {
        me.appendFeeds(result);
      } else {
        $('#stream .feed-loading').hide();
        $('#stream .more-feed').hide();
        me.streamEnded = true;
      }
    },
    error: function(result) {
      console.debug("Failed to fetch more feed.");
      console.debug(result);
      me.streamLoading = false;
      $('#stream .feed-loading').hide();
    }
    
  });
}

ActivityStream.prototype.appendFeeds = function(feedList) {
  var $stream = $('#stream');
  var htmlToAdd = [];
  var idsToAdd = [];
  for (index in feedList) {
    var feed = feedList[index];
    var $feed = $.tmpl(this.$feedTemplate, {
      id: feed.id,
      action: feed.action,
      guid: feed.object.guid,
      username: feed.user.username,
      description: feed.object.description,
      name: feed.object.name,
      time: new Date(feed.time),
      score: feed.object.score,
      thumbnail: feed.object.thumbnail,
      commentCount: feed.object.commentCount
    });
    
    if (feed.object.score > 0) {
      $('.event-score', $feed).addClass('event-score-positive');
      $('.event-score', $feed).text('+' + $('.event-score', $feed).text());
    } else if (feed.object.score < 0) {
      $('.event-score', $feed).addClass('event-score-negative');
    }
        
    htmlToAdd[index] = $feed.outerHtml();
    idsToAdd[index] = feed.id;
  }
  
  $('.feed-loading', $stream).hide();
  $('.stream-footer',$stream).before(htmlToAdd.join());
  
  for (index in idsToAdd) {
    var aid = idsToAdd[index];
    var $event = $('#stream .event[aid="' + aid + '"]');
    this.loadAnalysisByAjax($event);
  }
}

ActivityStream.prototype.loadAnalysisByAjax = function($feed) {
  var $title = $('.title a', $feed);
  var $thumb = $('.thumbnail a', $feed);
  var $comment = $('.event-footer a.comments-link', $feed)
  var name = $title.text();
  var href = $title.prop('href');
  var main = com.bouncingdata.Main;
  
  $title.click(function(e) {
    main.toggleAjaxLoading(true);
    window.history.pushState({linkId: href, type: 'anls'}, name, href);
    e.preventDefault();
  });
  
  $thumb.click(function(e) {
    main.toggleAjaxLoading(true);
    window.history.pushState({linkId: href, type: 'anls'}, name, href);
    e.preventDefault();
  });
  
  $comment.click(function(e) {
    main.toggleAjaxLoading(true);
    window.history.pushState({linkId: href, type: 'anls'}, name, href);
    e.preventDefault();
  });
  
  Spring.addDecoration(new Spring.AjaxEventDecoration({
    elementId: $title.prop('id'),
    event: "onclick",
    params: {fragments: "main-content"}
  }));
  
  Spring.addDecoration(new Spring.AjaxEventDecoration({
    elementId: $thumb.prop('id'),
    event: "onclick",
    params: {fragments: "main-content"}
  }));
  
  Spring.addDecoration(new Spring.AjaxEventDecoration({
    elementId: $comment.prop('id'),
    event: "onclick",
    params: {fragments: "main-content"}
  }));
}


com.bouncingdata.ActivityStream = new ActivityStream();

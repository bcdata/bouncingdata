function Dataset() {
  
}

Dataset.prototype.init = function(dataset) {
  var guid = dataset.guid;
  var me = this;
  this.votingCache = {};
  
  this.$commentTemplate = $('#comment-template').template();
  this.$commentEditor = $('#comment-editor-template').template();
  
  $(function() {
    $('#dataset-content').tabs();
    $('#related-tabs').tabs();
    SyntaxHighlighter.highlight();
    
    /*$('#comment-form #comment-submit').click(function() {
      // validate
      var message = $('#comment-form #message').val();
      if (!message) return;
      me.postComment(guid, message, -1, function() { $('#comment-form #message').val(''); });
    });

    $('.comments h3.comments-count').click(function() {
      $(this).next().toggle('slow');
    }).css('cursor', 'pointer');

    me.loadCommentList(guid);*/

    var $score = $('.header .score');
    var score = $score.text();
    if (score > 0) {
      $score.attr('class', 'score score-positive');
    } else {
      if (score == 0) $score.attr('class', 'score');
      else $score.attr('class', 'score score-negative');
    }

    $('.header a.vote-up').click(function() {
      me.voteDataset(guid, 1);
      return false;
    });

    $('.header a.vote-down').click(function() {
      me.voteDataset(guid, -1);
      return false;
    });
    
    $('a.add-tag-link').click(function() {
      $(this).next().show().addClass('active');
      return false;
    });
    
    $('div.add-tag-popup').click(function() {
      return false;
    });
    
    $(document).click(function() {
      var $addTagPopup = $('div.add-tag-popup');
      if ($addTagPopup.hasClass('active')) {
        $addTagPopup.removeClass('active');
        $addTagPopup.hide();
      }
    });
    
    $('.add-tag-popup #add-tag-button').click(function() {
      var tag = $('#add-tag-input').val();
      if (!tag) return false;
      $.ajax({
        url: ctx + '/dataset/' + guid + '/addtag',
        type: 'post',
        data: {
          tag: tag
        },
        success: function(res) {
          console.debug(res);
          if (res['code'] < 0) return;
          var $newTag = $('<div class="tag-element-outer"><a class="tag-element" href="javascript:void(0);">' + tag + '</a><span class="tag-remove" title="Remove tag from this datasetd">x</span></div>');
          $('.tag-set .tag-list').append($newTag);
          $('.tag-remove', $newTag).click(function() {
            var self = this;
            if (dataset.user != com.bouncingdata.Main.username) return;
            var tag = $(this).prev().text();
            $.ajax({
              url: ctx + '/dataset/' + guid + '/removetag',
              type: 'post',
              data: {
                tag: tag
              },
              success: function(res) {
                if (res['code'] < 0) {
                  console.debug(res);
                  return;
                }
                $(self).parent().remove();
              },
              error: function(res) {
                console.debug(res);
              }
            });
          });
        },
        error: function(res) {
          console.debug(res);
        }
      });
    });
    
    $('.tag-element-outer .tag-remove').click(function() {
      var self = this;
      if (dataset.user != com.bouncingdata.Main.username) return;
      var tag = $(this).prev().text();
      $.ajax({
        url: ctx + '/dataset/' + guid + '/removetag',
        type: 'post',
        data: {
          tag: tag
        },
        success: function(res) {
          if (res['code'] < 0) {
            console.debug(res);
            return;
          }
          $(self).parent().remove();
        },
        error: function(res) {
          console.debug(res);
        }
      });
    });
    
  });
}

Dataset.prototype.loadCommentList = function(guid) {
  console.debug("Comment list loaded");
}

Dataset.prototype.voteDataset = function(guid, score) {
  console.debug("Vote dataset: guid=" + guid + ", score=" + score);
}

com.bouncingdata.Dataset = new Dataset();
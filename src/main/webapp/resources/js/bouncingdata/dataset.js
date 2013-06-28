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
    
    //SyntaxHighlighter.highlight();
    
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
    
    // embedded
    $('.dataset-action-links a#dataset-embed-button').click(function() {
      var $embedded = $('#embedded-link-ds');
      $embedded.toggle('slow');
      // still not reversed the remote ip to hostname, temporarily hard code the host
      var host = "www.bouncingdata.com";
      var embedded = '<iframe src="http://' + host + ctx + '/public/dataset/embed/' + guid + '/?tab=v&tab=c&tab=d" style="border:solid 1px #777" width="800" height="600" frameborder="0"></iframe>';
      $('#embedded-link-text-ds', $embedded).val(embedded).click(function() {
        $(this).select();
        $(this).attr('title', 'Press CTRL-C to copy embedded code');
      });
    });
    
    $('.add-tag-popup #add-tag-button').click(function() {
      var tag = $('#add-tag-input').val();
      if (!tag) return false;
      $.ajax({
        url: ctx + '/tag/addtag',
        type: 'post',
        data: {
          'guid': guid,
          'tag': tag,
          'type': 'dataset'
        },
        success: function(res) {
          console.debug(res);
          if (res['code'] < 0) return;
          var $newTag = $('<div class="tag-element-outer"><a class="tag-element" href="' + ctx + "/tag/" + tag + '">' + tag + '</a><span class="tag-remove" title="Remove tag from this datasetd">x</span></div>');
          $('.tag-set .tag-list').append($newTag);
          $('.tag-remove', $newTag).click(function() {
            var self = this;
            if (dataset.user != com.bouncingdata.Main.username) return;
            var tag = $(this).prev().text();
            $.ajax({
              url: ctx + '/tag/removetag',
              type: 'post',
              data: {
                guid: guid,
                tag: tag,
                type: 'dataset'
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
        url: ctx + '/tag/removetag',
        type: 'post',
        data: {
          guid: guid,
          tag: tag,
          type: 'dataset'
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

Dataset.prototype.voteDataset = function(guid, vote) {
//  console.debug("Vote dataset: guid=" + guid + ", score=" + score);
	var me = this;
	  if (this.votingCache[guid] && this.votingCache[guid] * vote > 0) {
	    console.debug("You have voted this dataset " + guid + "already");
	    return;
	  }
	  
	  if (!this.votingCache[guid]) this.votingCache[guid] = 0;

	  $.ajax({
		  url: ctx + "/dataset/vote/" + guid,
		  data: {
			  vote: vote
		  },
		  type: 'post',
		  success: function(result) {
			  if(result=='1'){
				  var $score = $('.header .score');
				  if (vote >= 0) {
					  me.votingCache[guid]++;
					  $score.text($score.text() - (-1));
				  } 
				  else {
					  me.votingCache[guid]--;
					  $score.text($score.text() - 1);
				  }
				  var score = $score.text();
				  if (score > 0) {
					  $score.attr('class', 'score score-positive');
				  } else {
					  if (score == 0) 
						  $score.attr('class', 'score');
					  else 
						  $score.attr('class', 'score score-negative');
				  }
			  }
		  },
		  error: function(result) {
			  console.debug("Failed to vote dataset " + guid);
			  console.debug(result);
		  }
	  }); 
}

com.bouncingdata.Dataset = new Dataset();
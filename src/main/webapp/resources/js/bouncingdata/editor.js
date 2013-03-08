function Editor() {
  
}

Editor.prototype.init = function(anls) {
  var me = this;
  me.anls = anls;
  
  $(function() {
    
    com.bouncingdata.Main.toggleLeftNav();
    
    //initialize ace editor
    var editorDom = $('.editor-container .code-editor')[0];
    me.editor = ace.edit(editorDom);
    me.editor.getSession().setMode('ace/mode/python');
    
    me.editor.getSession().getDocument().setValue(anls.code);
    
    // logs
    me.jqConsole = $('.editor-container .execution-logs .console').jqconsole('Welcome to our console\n', Utils.getConsoleCaret('python'));
    me.startPrompt(me.jqConsole, 'python');
    
    me.$message = $(".editor-status .status-message");
    me.$loading = $(".editor-status .ajax-loading");
    
    $('button#editor-execute').click(function() {
      me.execute();
    });
    
  });
}

/**
 * Initializes the logging console prompt
 */
Editor.prototype.startPrompt = function(jqconsole, language) {
  var me = this;
  jqconsole.Prompt(true, function(input) {
    $.ajax({
      url: ctx + "/shell/execute",
      type: "get",
      data: {
        code: input,
        language: language
      },
      success: function(result) {
        jqconsole.Write(result + '\n', 'jqconsole-output');
        me.startPrompt(jqconsole, language);
      },
      error: function(result) {
        console.info(result);
        me.startPrompt(jqconsole, language);
      }
    });
  });
}

Editor.prototype.initSize = function(anls, dbDetail) {
  var me = this;
  me.anls = anls;
  this.loadedData = false;
  $(function() {
    com.bouncingdata.Main.toggleLeftNav();
    var $tabs = $('#size-tabs').tabs();
    
    // set code
    $('#size-code .code-block pre').text(anls["code"]);
    SyntaxHighlighter.highlight();
    
    var $dashboard = $('#viz-dashboard', $tabs);
    me.loadDashboard(dbDetail.visualizations, dbDetail.dashboard, $dashboard, anls);
    
    // load data
    $('#size-tabs').bind('tabsselect', function(event, ui) {
      // select data tab
      if (ui.index == 2 && me.loadedData == false) {
        var $dataPanel = $('#size-data');
        var dsguids = '';
        $('.anls-dataset', $dataPanel).each(function() {
          dsguids += $(this).attr('dsguid') + ',';
        });
        dsguids = dsguids.substring(0, dsguids.length - 1);
        if (dsguids.length > 0) {
          com.bouncingdata.Utils.setOverlay($dataPanel, true);
          $.ajax({
            url: ctx + '/dataset/m/' + dsguids,
            type: 'get',
            dataType: 'json',
            success: function(result) {
              com.bouncingdata.Utils.setOverlay($dataPanel, false);
              $('.anls-dataset', $dataPanel).each(function() {
                var dsguid = $(this).attr('dsguid');
                var $table = $('table', $(this));
                var data = result[dsguid].data;
                if (data) {
                  com.bouncingdata.Workbench.renderDatatable($.parseJSON(data), $table);
                } else if (result[dsguid].size > 0) {
                  console.debug("Load datatable by Ajax...");
                  var columns = result[dsguid].columns;
                  com.bouncingdata.Workbench.loadDatatableByAjax(dsguid, columns, $table);
                }
              });
              me.loadedData = true;
            },
            error: function(result) {
              com.bouncingdata.Utils.setOverlay($dataPanel, false);
              console.debug('Failed to load datasets.');
              console.debug(result);
              $dataPanel.text('Failed to load datasets.');
            }
          });
        }
      }
    });
    
    
  });
}

Editor.prototype.initDescribe = function(anls) {
  $(function() {
    $('.detail-area #name').val(anls.name);
    $('.detail-area #description').val(anls.description);
    tinyMCE.init({
      mode : "textareas",
      theme : "advanced",
      plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,wordcount,advlist,autosave,visualblocks",

      // Theme options
      theme_advanced_buttons1 : "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,formatselect,fontselect,fontsizeselect",
      theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
      theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
      theme_advanced_buttons4 : "insertlayer,moveforward,movebackward,absolute,|,styleprops,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,pagebreak,restoredraft,visualblocks",
      theme_advanced_toolbar_location : "top",
      theme_advanced_toolbar_align : "left",
      theme_advanced_statusbar_location : "bottom",
      theme_advanced_resizing : true
    });
  });
}


Editor.prototype.loadDashboard = function(visuals, dashboard, $dashboard, anls) {
  $dashboard.attr('guid', anls['guid']).attr('tabid', 1); 
  com.bouncingdata.Dashboard.load(visuals, dashboard, $dashboard, anls.user.username==com.bouncingdata.Main.username);
}

Editor.prototype.execute = function() {
  var me = this;
  var code = me.editor.getSession().getDocument().getValue();
  var type = 'analysis';
  me.setStatus("running");
  
  $.ajax({
    url: ctx + "/app/e/" + me.anls.guid,
    type: 'post',
    data: {
      code: code,
      language: me.anls.language,
      type: type
    },
    success: function(result) {
      if (result['statusCode'] >= 0) {
        me.setStatus("finished-running");
        me.jqConsole.Write(result['output'], 'jqconsole-output');
        me.startPrompt(me.jqConsole, 'python');
        
          // reload datasets & viz.
        if (type == 'analysis') {
          //me.reloadDashboard(app, $tab);
          //app.executed = true;
          var datasets = result['datasets'];
          //var $dsContainer = $('#' + tabId + '-data', $tab);
          //$dsContainer.empty();
          //me.renderDatasets(datasets, $dsContainer);
          console.debug(result)
        } else if (type == 'scraper') {
          var datasets = result['datasets'];
          var $dsContainer = $('#' + tabId + '-data', $tab);
          //for (name in datasets) {
          //  var data = datasets[name];
          //  me.renderDataset(name, data, $dsContainer);
          //}
          
          me.renderDatasets(datasets, $dsContainer);
        }
        
        
      } else {
        console.debug(result);
        me.setStatus("error");
        me.jqConsole.Write(result['output'], 'jqconsole-output');
      }
    },
    error: function(msg) {
      console.debug(msg);
      me.setStatus("error");
    }
  });
  
}

Editor.prototype.setStatus = function(status) {
  if (status) {
    switch(status) {
    case "running":
      this.$message.text("Running...").css("color", "green");
      this.$loading.css("opacity", 1);
      break;
    case "finished-running":
      this.$message.text("Finished running.").css("color", "green");;
      this.$loading.css("opacity", 0);
      break;
    case "error":
      this.$loading.css("opacity", 0);
      this.$message.text("Error").css("color", "red");
      break;
    default:
      this.$message.text("");
      this.$loading.css("opacity", 0);
    }
  } else {
    this.$message.text("");
    this.$loading.css("opacity", 0);
  }
}

Editor.prototype.initProgressLinks = function() {
  var me = this;
  var $code = $('.top-bar .editor-progress a.editor-code-link');
  var $size = $('.top-bar .editor-progress a.editor-size-link');
  var $describe = $('.top-bar .editor-progress a.editor-describe-link');
  
  $code.click(function() {
    com.bouncingdata.Nav.fireAjaxLoad(ctx + '/editor/anls/' + me.anls.guid + '/edit', false); 
    return false;
  });
  
  $size.click(function() {
    com.bouncingdata.Nav.fireAjaxLoad(ctx + '/editor/anls/' + me.anls.guid + '/size', false); 
    return false;
  });
  
  $describe.click(function() {
    com.bouncingdata.Nav.fireAjaxLoad(ctx + '/editor/anls/' + me.anls.guid + '/describe', false); 
    return false;
  });
}

Editor.prototype.newAnalysis = function(name, language, isPublic) {
  var data = {
    appname : name,
    language : language,
    description : '',
    code : '',
    isPublic : isPublic,
    tags : '',
    type : 'analysis'
  };
  
  var me = this;
  
  $.ajax({
    url: ctx + "/main/createapp",
    data: data,
    type: "post",
    success: function(anls) {
      window.location = ctx + '/editor/anls/' + anls.guid + '/edit';
    },
    error: function(res) {
      console.debug(res)
    }
  });
}

com.bouncingdata.Editor = new Editor();
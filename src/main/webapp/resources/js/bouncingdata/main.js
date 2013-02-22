function Main() {
  // these fields keep tract of css/js asynchronous loading, each file should loaded 1 time.
  this.cssLoader = {};
  this.jsLoader = {};
}

Main.prototype.setContext = function(ctx) {
  this.ctx = ctx;
}

Main.prototype.init = function() {
  this.workbenchSession = {};
  $(function() {

    $('input:button, input:submit, button').button();

    // initializes main navigation & ajax loading capabilities
    com.bouncingdata.Nav.init();

    // search form submit
    $('.search-container #search-form').submit(function(e) {
      e.preventDefault();
      var query = $('#query', $(this)).val();
      var criteria = $('#criteria', $(this)).val();
      if (!query || !criteria) return false;
      com.bouncingdata.Nav.fireAjaxLoad(ctx + '/main/search/?query=' + query + '&criteria=' + criteria, false);
      return false;
    });

    // inits. popups
    com.bouncingdata.Main.initPopups();

    // inits. history stack with the first state
    window.history.pushState({linkId: window.location.href}, null, window.location.href);

  });
}

/**
 * Inits global-scope popup dialogs
 */
Main.prototype.initPopups = function() {
  var me = this;
  this.$newDialog = $('.popup-container > #new-dialog').dialog({
    autoOpen: false,
    width: 470,
    modal: true,
    resizable: false,
    buttons: {
      "Create": function() {
        var self = $(this);
        // validate
        var name = $('#script-name', self).val();
        var language = $('#script-language', self).val();
        var isPublic = $('#script-privacy-public', self).prop('checked');
        var type = $('#script-type', self).val();

        if (!name || $.trim(name).length < 1) {
          return;
        }

        // if current page is not the 'create' page
        if (com.bouncingdata.Nav.selected['ref'] != 'create') {
          com.bouncingdata.Workbench.callback = function() {
            com.bouncingdata.Workbench.newScript(type, name, language, "", isPublic, "");
          }
          com.bouncingdata.Nav.openWorkbench();
        } else {
          com.bouncingdata.Workbench.newScript(type, name, language, "", isPublic, "");
        }

        self.dialog('close');
      },
      "Cancel": function() {
        $(this).dialog('close');
      }

    },
    open: function(event, ui) {
      $('form', $(this))[0].reset();
      $('.ui-widget-overlay').bind('click', function(){ me.$newDialog.dialog('close'); });
    },

    create: function(event, ui) {
      var self = $(this);
      $('.entity-list a.new-anls, .entity-list a.new-scraper', self).click(function() {
        $('.entity-chooser', self).hide();
        $('.new-script-wrapper', self).show();
        $('.ui-dialog-buttonpane', self.parent()).show();
        $('#script-name', self).focus();

        if ($(this).hasClass('new-scraper')) {
          $('#script-type', self).val('scraper');
        } else {
          $('#script-type', self).val('analysis');
        }
      });

      $('.entity-list a.upload-data', self).click(function() {
        self.dialog("close");
        me.$uploadDataDialog.dialog("open");
      });
    }
  });

  /**
   * Parameterized the 'open' method of the new dialog
   * @param type the type, empty for the entity chooser, "viz" for the new visualization form or "scraper" for new scraper
   */
  this.$newDialog.open = function(type) {
    var self = $(this);
    if (!type) {
      self.dialog("open");
      $('.entity-chooser', self).show();
      $('.new-script-wrapper',  self).hide();
      $('.ui-dialog-buttonpane', self.parent()).hide();
    } else if (type == "viz") {
      self.dialog("open");
      $('.entity-chooser', self).hide();
      $('.new-script-wrapper',  self).show();
      $('.ui-dialog-buttonpane', self.parent()).show();

      $('.new-script-form #script-type', self).val('analysis');
      $('.new-script-form #script-name', self).focus();
    } else if (type == "scraper") {
      self.dialog("open");
      $('.entity-chooser', self).hide();
      $('.new-script-wrapper',  self).show();
      $('.ui-dialog-buttonpane', self.parent()).show();
      $('.new-script-form #script-type', self).val('scraper');
      $('.new-script-form #script-name', self).focus();
    }

  }

  this.$uploadDataDialog = $('.popup-container > #upload-data-dialog').dialog({
    autoOpen: false,
    width: 470,
    modal: true,
    resizable: false,
    buttons: {
      "Upload": function() {
        me.submitDataset();
      },
      "Cancel": function() {
        $(this).dialog('close');
      },
      "Save": function() {
        me.persistDataset();
      }
    },
    open: function(event, ui) {
      $('#file-upload-form', me.$uploadDataDialog)[0].reset();
      $('.upload-status', me.$uploadDataDialog).text('Maximum file size is 20MB').show();
      $('.preview-panel', me.$uploadDataDialog).hide();
      $('#schema-table tbody', me.$uploadDataDialog).empty();
      me.$uploadDataDialog['ticket'] = null;
      //$('.ui-dialog-buttonpane ', me.$uploadDataDialog.parent())
      $('.ui-widget-overlay').bind('click', function(){ me.$uploadDataDialog.dialog('close'); });
    },
    close: function(event, ui) {
      me.$uploadDataDialog['ticket'] = null;
    }
  });

  this.$publishDialog = $('.popup-container > #publish-dialog').dialog({
    autoOpen: false,
    width: 470,
    modal: true,
    resizable: false,
    buttons: {
      "Post": function() {
        if (!me.$publishDialog['object']) {
          console.debug("No analysis/dataset to publish.");
          return;
        }
        var object = me.$publishDialog['object'];
        var message = $('.publish-message', $(this)).val();
        if (!message || $.trim(message).length <= 0) return;

        me.publish(object['guid'], message);

        me.$publishDialog['object'] = null;
        $(this).dialog('close');
      },
      "Cancel": function() {
        $(this).dialog('close');
      }
    },
    open: function(event, ui) {
      var object = me.$publishDialog['object'];
      if (!object) return false;

      $('.publish-message', $(this)).focus();
      $('.title', $(this)).text(object['name']);
      $('.ui-widget-overlay').bind('click', function(){ me.$publishDialog.dialog('close'); })
    }
  });
}

/**
 * Publish a post with an analysis
 * @param guid
 * @param message
 */
Main.prototype.publish = function(guid, message) {
  var me = this;
  $.ajax({
    url: ctx + '/main/publish',
    type: 'post',
    data: {
      guid: guid,
      message: message
    },
    success: function(res) {
      if (res['code'] >= 0) {
        console.debug('Successfully post.');
      } else {
        console.debug('Error message: ' + res['message']);
      }
    },
    error: function(res) {
      console.debug(res);
    }
  });
}

/**
 * The first step to upload a dataset, submit dataset file to server
 */
Main.prototype.submitDataset = function() {
  console.debug("Upload dataset file...");
  var $uploadDataDialog = this.$uploadDataDialog;
  var $form = $('form#file-upload-form', $uploadDataDialog);
  //var file = $form.prop('value');
  var file = $('#file', $form).val();
  if (!file) {
    return;
  }
  // determine file type
  if (file.indexOf('/') > -1) file = file.substring(file.lastIndexOf('/') + 1);
  else if (file.indexOf('\\') > -1) file = file.substring(file.lastIndexOf('\\') + 1);

  if (file.indexOf('.') < 0) {
    $('.upload-status', $form).text('This file could not be imported. Supported formats: .xls, .xlsx, .csv, .txt').show();
    return;
  }

  var extension = file.substring(file.lastIndexOf('.') + 1);
  var filename = file.substring(0, file.lastIndexOf('.'));
  if ($.inArray(extension, ['xls', 'xlsx', 'csv', 'txt']) < 0) {
    $('.upload-status', $form).text('This file could not be imported. Supported formats: .xls, .xlsx, .csv, .txt').show();
    return;
  }

  $('.upload-in-progress', $form).show();
  $('.upload-status', $form).text('Uploading in progress').show();
  $form.ajaxSubmit({
    url: ctx + '/dataset/up',
    type: 'post',
    data: {
      type: extension
    },
    clearForm: true,
    resetForm: true,
    success: function(res) {
      $('.upload-in-progress', $form).hide();
      /*if (res < 0) {
       $('.upload-status', $form).text('Upload failed! Your file may not valid.');
       return;
       }
       console.debug("Uploaded successfully!");
       $('.upload-status', $form).text(res +  ' bytes uploaded successfully');*/

      if (res['code'] < 0) {
        $('.upload-status', $form).text('Upload failed! Your file may not valid.');
        console.debug(res['message']);
        return;
      }
      $('.upload-status', $form).text('Uploaded successfully');

      console.debug("Message: " + res['message']);
      console.debug(res['object']);

      var ticket = res['object'][0];
      $uploadDataDialog['ticket'] = ticket;
      var schema = res['object'][1];
      var $schemaTableBody = $('#schema-table tbody', $uploadDataDialog);
      var index;
      for (index in schema) {
        var column = schema[index];
        var $row = $('<tr><td>' + index + '</td><td>' + column['name'] + '</td><td>'
            + '<select class="column-type-select"><option value="Boolean">Boolean</option>'
            + '<option value="Integer">Integer</option><option value="Long">Long</option>'
            + '<option value="Double">Double</option><option value="String">String</option>'
            + '</select></td></tr>');
        $schemaTableBody.append($row);
        $('select.column-type-select', $row).val(column['typeName']);
      }

      $('.preview-panel', $uploadDataDialog).show();
      $('.preview-panel .dataset-name', this.$uploadDataDialog).val(filename).focus();
    },
    error: function(err) {
      $('.upload-status', $form).text('Failed to upload');
      console.debug(err);
    }
  });
}

/**
 * The second step to upload dataset: preview & decide the schema, dataset name.
 */
Main.prototype.persistDataset = function() {
  var me = this;
  var ticket = this.$uploadDataDialog['ticket'];
  if (!ticket) {
    return;
  }

  var name = $('.preview-panel .dataset-name', this.$uploadDataDialog).val();
  if (!name) {
    return;
  }

  // submit schema to server to persist data
  var $schemaTableBody = $('#schema-table tbody', this.$uploadDataDialog);
  var schema = [];
  $('tr', $schemaTableBody).each(function() {
    var $tds = $('td', $(this));
    schema.push([$.trim($($tds[1]).text()), $('select.column-type-select', $tds[2]).val()])
  });

  var schemaStr = JSON.stringify(schema);
  console.debug("Name: " + name + "; Schema: " + schemaStr);
  $.ajax({
    url: ctx + '/dataset/persist',
    type: 'post',
    data: {
      ticket: ticket,
      name: name,
      schema: schemaStr
    },
    success: function(res) {
      console.debug(res);
      if (res['code'] < 0) {
        window.alert("Failed to upload dataset.\nError: " + res['message']);
        return;
      }
      var guid = res['object'];
      me.$uploadDataDialog.dialog('close');
      if (window.confirm("Your dataset \"" + name + "\" has been uploaded successfully. Open it now?")) {
        com.bouncingdata.Nav.fireAjaxLoad(ctx + '/dataset/view/' + guid, false);
      }
    },
    error: function(msg) {
      console.debug('Failed to make request to persist data');
      console.debug(msg);
    }
  });
}

/**
 * Show/hide the ajax loading message on the top of page
 * @param display
 * @param message
 */
Main.prototype.toggleAjaxLoading = function(display, message) {
  var $element = $('body > #ajaxLoadingMessage');
  if (display) $('span.ajaxLoadingMessage', $element).text(message?message:'Loading...')
  if (display) {
    $element.show();
  } else $element.hide();
}

/**
 * Loads CSS asynchronously
 * @param cssUrl
 * @param pageName
 */
Main.prototype.loadCss = function(cssUrl, pageName) {
  if (!com.bouncingdata.Main.cssLoader[pageName]) {
    /*$.ajax({
     url: cssUrl,
     success: function(result) {
     var $style = $('head style');
     if ($style.length <= 0) {
     $style.appendTo('head');
     }
     $style.append(result);
     com.bouncingdata.Main.cssLoader[pageName] = true;
     console.debug("Css file " + cssUrl + " anync. loaded successfully.");
     },
     error: function(result) {
     console.debug("Failed to load css from " + cssUrl);
     console.debug("Error: " + result);
     }
     });*/
    var $head = $('head');
    $head.append('<link rel="stylesheet" type="text/css" href="' + cssUrl + '" /> ');
    com.bouncingdata.Main.cssLoader[pageName] = true;
  } else {
    console.debug("Css file " + cssUrl + " was loaded before.");
  }
}

function Utils() {
}

Utils.prototype.getConsoleCaret = function(language) {
  if (language == "python") return ">>>";
  else if (language == "r") return ">";
  else return null;
}

/**
 * Leverages the datatable plugin
 * @param data
 * @param $table
 */
Utils.prototype.renderDatatable = function(data, $table) {
  if (!data || data.length <= 0) return;

  //prepare data
  var first = data[0];
  var aoColumns = [];
  for (key in first) {
    aoColumns.push({ "sTitle": key});
  }

  var aaData = [];
  for (index in data) {
    var item = data[index];
    var arr = [];
    for (key in first) {
      arr.push(item[key]);
    }
    aaData.push(arr);
  }
  var datatable = $table.dataTable({
    "aaData": aaData,
    "aoColumns": aoColumns,
    "bJQueryUI": true,
    "sPaginationType": "full_numbers"
  });
  var keys = new KeyTable( {
    "table": $table[0],
    "datatable": datatable
  });
}

/**
 * Makes an overlay layer with ajax loading animation on top of a panel
 * @param $panel jQuery object represents the panel
 * @param isActive turn overlay on or off
 */
Utils.prototype.setOverlay = function($panel, isActive) {
  if (isActive) {
    var $overlay = $('<div class="overlay-panel" style="position: absolute; top: 0; bottom: 0; left: 0; right: 0;"></div>');
    $overlay.css('background', 'url("' + ctx + '/resources/images/ajax-loader.gif") no-repeat 50% 10% #eee')
        .css('z-index', 10).css('background-size', '30px 30px').css('opacity', '0.8');
    if (!$panel.css('position')) {
      $panel.css('position', 'relative');
    }
    $panel.append($overlay);
  } else {
    $('div.overlay-panel', $panel).remove();
  }
}

com = {};
com.bouncingdata = {};
com.bouncingdata.Main = new Main();
com.bouncingdata.Utils = new Utils();
Utils = com.bouncingdata.Utils;
com.bouncingdata.Main.init();

/**
 * Extra function for jQuery, to get html content of an jQuery object, including outer tag.
 * Use it as: <code>$object.outerHtml()</code>
 */
(function($) {
  $.fn.outerHtml = function() {
    return $(this).clone().wrap('<div></div>').parent().html();
  }
})(jQuery);
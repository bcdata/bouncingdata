function Upload() {
  
}

Upload.prototype.init = function() {
  var me = this;
  $(function() {    
    com.bouncingdata.Main.toggleLeftNav();
    $('.upload-nav').button();
    
    $('#upload-submit').click(function() {
      me.submitDataset();
      return false;
    });
  });
}

Upload.prototype.initSchema = function(ticket, detectedSchema) {
  var me = this;
  $(function() {
    com.bouncingdata.Main.toggleLeftNav();
    $('.schema-nav').button();
    
    $('#schema-panel').tabs().tabs('select', 1);
    
    tinyMCE.init({
      mode : "textareas",
      theme : "simple",
      plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,wordcount,advlist,autosave,visualblocks",

      // Theme options
      theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,formatselect,fontselect,fontsizeselect",
      theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
      theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
      theme_advanced_toolbar_location : "top",
      theme_advanced_toolbar_align : "left",
      theme_advanced_statusbar_location : "bottom",
      theme_advanced_resizing : true
    });  
    
    var $schemaTableBody = $('#schema-table tbody');
    var index;
    var tableHtml = [];
    for (index in detectedSchema) {
      var column = detectedSchema[index];
      tableHtml[index] = '<tr detected="' + column['typeName'] + '"><td>' + column['name'] + '</td><td>'
          + '<select class="column-type-select"><option value="Boolean">Boolean</option>'
          + '<option value="Integer">Integer</option><option value="Long">Long</option>'
          + '<option value="Double">Double</option><option value="String">String</option>'
          + '</select></td><td><input type="text" class="column-description" /></td></tr>'
    }
    
    $schemaTableBody.append(tableHtml.join());
    
    $('#schema-table tr').each(function() {
      $('select.column-type-select', $(this)).val($(this).attr('detected'));
    });

    $('#schema-submit').click(function() {
      // submit schema to server to persist data
      var name = $('.description-panel #name').val();
      if (!name) {
        alert('Dataset name must not empty');
        $('.description-panel #name').focus();
        return;
      }
      var description = tinymce.editors[0].getContent();
      
      var schema = [];
      $('tr', $schemaTableBody).each(function() {
        var $tds = $('td', $(this));
        schema.push([$.trim($($tds[0]).text()), $('select.column-type-select', $tds[1]).val()])
      });

      var schemaStr = JSON.stringify(schema);
      
      console.debug("Name: " + name + "; Schema: " + schemaStr);
      $.ajax({
        url: ctx + '/dataset/persist',
        type: 'post',
        data: {
          ticket: ticket,
          name: name,
          schema: schemaStr,
          description: description
        },
        success: function(res) {
          console.debug(res);
          if (res['code'] != 0) {
            window.alert("Failed to upload dataset.\nError: " + res['message']);
            return;
          }
          var guid = res['object'];
          if (window.confirm("Your dataset \"" + name + "\" has been uploaded successfully. Open it now?")) {
            //com.bouncingdata.Nav.fireAjaxLoad(ctx + '/dataset/view/' + guid, false);
            window.location.href = ctx + '/dataset/view/' + guid; 
          }
        },
        error: function(msg) {
          console.debug('Failed to make request to persist data');
          console.debug(msg);
          alert('Failed to upload dataset.');
        }
      });
    });
  });
}

/**
 * The first step to upload a dataset, submit dataset file to server
 */
Upload.prototype.submitDataset = function() {
  console.debug("Upload dataset file...");
  var $form = $('form#upload-form');
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

  var $uploadProgress = $('.upload-in-progress', $form).show();
  var $uploadStatus = $('.upload-status', $form).text('Uploading in progress').show();
  
  $form.submit();
}

com.bouncingdata.Upload = new Upload();
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

Upload.prototype.initSchema = function() {
  var me = this;
  $(function() {
    
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
  
  /*$form.ajaxSubmit({
    url: ctx + '/dataset/upload/schema',
    type: 'post',
    data: {
      type: extension
    },
    clearForm: true,
    resetForm: true,
    success: function(res) {
      $uploadProgress.hide();
      if (res < 0) {
       $('.upload-status', $form).text('Upload failed! Your file may not valid.');
       return;
       }
       console.debug("Uploaded successfully!");
       $('.upload-status', $form).text(res +  ' bytes uploaded successfully');

      if (res['code'] < 0) {
        $uploadStatus.text('Upload failed! Your file may not valid.');
        console.debug(res['message']);
        return;
      }
      
      $uploadStatus.text('Uploaded successfully');

      console.debug("Message: " + res['message']);
      console.debug(res['object']);

      var ticket = res['object'][0];
      //$uploadDataDialog['ticket'] = ticket;
      var schema = res['object'][1];
      //var $schemaTableBody = $('#schema-table tbody', $uploadDataDialog);
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

      //$('.preview-panel', $uploadDataDialog).show();
      //$('.preview-panel .dataset-name', this.$uploadDataDialog).val(filename).focus();
    
      // go to schema page with a post
    },
    error: function(err) {
      $uploadProgress.hide();
      $uploadStatus.text('Failed to upload');
      console.debug(err);
    }
  });*/
}

com.bouncingdata.Upload = new Upload();
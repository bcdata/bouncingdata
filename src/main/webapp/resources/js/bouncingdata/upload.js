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
    com.bouncingdata.Main.toggleLeftNav();
    
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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script type="text/javascript">
  com.bouncingdata.Main.loadCss(ctx + "/resources/css/bouncingdata/upload.css", "upload");

  if (!com.bouncingdata.Upload) {
    $.getScript(ctx + "/resources/js/bouncingdata/upload.js", function() {
      console.debug("upload.js async. loaded!");
      com.bouncingdata.Upload.init();
    });  
  } else {
    com.bouncingdata.Upload.init();
  }
</script>


<div id="main-content" class="upload-container">
  <div class="top-bar">
    <div class="left-buttons">
      <button class="close-button">Close</button>
    </div>
    <div class="upload-nav-panel">
      <a class="upload-nav" id="upload-submit" href="javascript:void(0)">Submit</a>
    </div>
    <div class="progress upload-progress">
      <a class="progress-step upload-step upload-file progress-current" style="border-color: red;">File</a>
      <a class="progress-step upload-step upload-schema">Schema & Description</a>
    </div>
  </div>
  <div class="clear-bar"></div>
  <div class="upload-container center-content-container">
    <c:if test="${not empty errorMsg}">
      <div class="error-block" id="error-msg">
        <strong style="color: red; ">${errorMsg}</strong>
      </div>
    </c:if>
    <div class="upload-form-wrapper">
      <form id="upload-form" method="post" action="<c:url value="/dataset/upload/schema" />" enctype="multipart/form-data">
        <div>
          <img alt="Uploading" src="<c:url value="/resources/images/loader32.gif" />" class="upload-in-progress" style="display: none;" />&nbsp;
          <span class="upload-status"></span>
        </div>
        <h3>1. File Location</h3>
        <span>We support the following types: csv, xls, xlsx, txt, rdata</span>
        <div>
          <label>Web Address</label>
          <input type="text" name="fileUrl" id="fileUrl" />
          <div style="font-size: 15px;">Or</div>         
          <label>Local File</label>
          <input type="file" id="file" name="file" />
        </div>
      </form>
    </div>
    <div class="upload-options-wrapper">
      <form id="upload-options-form">
        <h3>2. Loading Options</h3>
        <div>
          <label>Header</label>
          <input type="checkbox" value="First row is header" />
          <label>Delimiter</label>
          <select>
            <option value="comma">Comma</option>
            <option value="tab">Tab</option>
            <option value="period">Period</option>
          </select>
        </div>
      </form>
    </div>
  </div>

</div>
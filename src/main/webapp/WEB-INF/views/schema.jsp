<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script type="text/javascript">
  com.bouncingdata.Main.loadCss(ctx + "/resources/css/bouncingdata/upload.css", "upload");

  if (!com.bouncingdata.Upload) {
    $.getScript(ctx + "/resources/js/bouncingdata/upload.js", function() {
      console.debug("upload.js async. loaded!");
      com.bouncingdata.Upload.initSchema();
    });  
  } else {
    com.bouncingdata.Upload.initSchema();
  }
</script>

<div id="main-content" class="data-schema-container">
  <div class="top-bar">
    <div class="left-buttons">
      <button class="close-button">Close</button>
    </div>
    <div class="schema-nav-panel">
      <a class="schema-nav" id="schema-submit" href="javascript:void(0)">Submit</a>
    </div>
    <div class="progress upload-progress">
      <a class="progress-step upload-step upload-file">File</a>
      <a class="progress-step upload-step upload-schema progress-current" style="border-color: red;">Schema & Description</a>
    </div>
  </div>
  <div class="clear-bar"></div>
  <div class="schema-container center-content-container">
    <div class="schema-table-wrapper">
      <div id="schema-table">
        <h3>1. Schema</h3>
        <span>${schema }</span>  
      </div>
    </div>
    <div class="description-wrapper">
      <form id="description-form">
        <h3>2. Description</h3>
        <div>
          <label>Dataset Name</label>
          <input type="text" name="name" id="name" />
          <label>Description</label>
          <textarea name="description" id="description"></textarea>
        </div>
        <div class="tag-set" id="tag-set">
          <span class="tag-list">
            <a class="tag-element" href="javascript:void(0);">Football</a>
            <a class="tag-element" href="javascript:void(0);">Money</a>
            <a class="tag-element" href="javascript:void(0);">Madrid</a>
          </span>
          <a class="add-tag-button>" href="javascript:void()">
            Add tag
          </a>
        </div>
      </form>
    </div>
  </div>
</div>
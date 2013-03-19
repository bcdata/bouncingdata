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

<div id="main-content" class="upload-container">
  <div class="top-bar">
    <div class="left-buttons">
      <button class="close-button">Close</button>
    </div>
    <div class="schema-nav-panel">
      <a class="schema-nav" id="schema-submit" href="javascript:void(0)">Submit</a>
    </div>
    <div class="progress upload-progress">
      <div class="progress-step upload-step upload-file">File</div>
      <div class="progress-step upload-step upload-schema progress-current">Schema & Description</div>
    </div>
  </div>
  <div class="clear-bar"></div>
  <div class="schema-container center-content-container">
    <div class="schema-panel-wrapper">
      <h3>1. Schema</h3>
      <span></span>
      <div class="schema-panel" id="schema-panel">
        <ul>
          <li>View</li>
          <li>Schema</li>
          <li>Add Reference Doc</li>
        </ul>
        <div id="schema-tab-view"></div>
        <div id="schema-tab-schema"></div>
        <div id="schema-tab-reference"></div>
      </div>
      <span>${schema }</span>  
    </div>
    <div class="description-panel-wrapper">
      <h3>2. Description</h3>
      <span></span>
      <div class="description-panel">
        <div>
          <label>Dataset Name</label>
          <input type="text" name="name" id="name" /><br><br>
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
      </div>
    </div>
  </div>
</div>
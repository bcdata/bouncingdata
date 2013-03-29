<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script type="text/javascript">
  com.bouncingdata.Main.loadCss(ctx + "/resources/css/bouncingdata/upload.css", "upload");
  var schema = $.parseJSON('${schema}');
  var ticket = '${ticket}';
  if (!com.bouncingdata.Upload) {
    $.getScript(ctx + "/resources/js/bouncingdata/upload.js", function() {
      console.debug("upload.js async. loaded!");
      com.bouncingdata.Upload.initSchema(ticket, schema);
    });  
  } else {
    com.bouncingdata.Upload.initSchema(ticket, schema);
  }
</script>

<div id="main-content" class="upload-container">
  <div class="top-bar">
    <div class="left-buttons">
      <button class="close-button">Close</button>
    </div>
    <div class="schema-nav-panel">
      <a class="schema-nav" id="schema-back" href="<c:url value="/dataset/upload" />">Back</a>
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
      <div class="schema-panel schema-tabs ui-tabs" id="schema-panel">
        <ul>
          <li><a href="#schema-tab-view">View</a></li>
          <li><a href="#schema-tab-schema">Schema</a></li>
          <li><a href="#schema-tab-reference">Add Reference Doc</a></li>
        </ul>
        <div class="clear"></div>
        <div id="schema-tab-view" class="ui-tabs-hide">
          <div class="data-preview-wrapper">
            <table id="data-preview"></table>
            <c:choose>
              <c:when test="${not empty data }">
                <script>
                  var data = ${data};
                  var $table = $('#data-preview');
                  com.bouncingdata.Workbench.renderDatatable(data, $table);
                </script>
              </c:when>
              <c:otherwise>
                <!-- script>
                $(function() {
                  console.debug("Load datatable by Ajax...");
                  var guid = '${guid}';
                  var columns = ${columns};
                  var $table = $('#data-table');
                  com.bouncingdata.Workbench.loadDatatableByAjax(guid, columns, $table);               
                });
                </script-->
                <span>Unable to load data preview</span>  
              </c:otherwise>
            </c:choose>
          </div>
        </div>
        <div id="schema-tab-schema" class="ui-tabs-hide">
          <div class="schema-table-wrapper">
            <table id="schema-table" ticket="${ticket }">  
              <thead>
                <tr>
                  <th><strong>Column Name</strong></th>
                  <th><strong>Data Type</strong></th>
                  <th><strong>Description</strong></th>
                </tr>
              </thead>
              <tbody></tbody>           
            </table>
          </div>
          <button id="recommended-schema">Recommended schema</button>
        </div>
        <div id="schema-tab-reference" class="ui-tabs-hide">
          <div class="reference-form">
            <label>Web</label>
            <input type="text" name="web-ref" id="web-ref" />
            <h3>Or</h3>
            <label>Local</label>
            <input type="file" name="file-ref" id="file-ref" />
          </div>
        </div>
          
      </div>  
    </div>
    <div class="description-panel-wrapper">
      <h3>2. Description</h3>
      <div class="description-panel">
        <div>
          <label>Dataset Name</label>
          <input type="text" name="name" id="name" /><br><br>
          <label>Description</label>
          <textarea name="description" id="description" style="width: 100%;"></textarea>
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
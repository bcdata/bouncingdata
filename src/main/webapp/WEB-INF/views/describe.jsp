<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script type="text/javascript">
  com.bouncingdata.Main.loadCss(ctx + "/resources/css/bouncingdata/editor.css", "editor");

  var anls = {
    guid: '${anls.guid}',
    code: '${anlsCode}'
  }
  // supports async. load js but we really should pre-load workbench.js from the layout.jsp
  if (!com.bouncingdata.Editor) {
    $.getScript(ctx + "/resources/js/bouncingdata/editor.js", function() {
      console.debug("editor.js async. loaded!");
      com.bouncingdata.Editor.initDescribe(anls);
    });  
  } else {
    com.bouncingdata.Editor.initDescribe(anls);
  }
</script>

<div id="main-content" class="editor-container">
  <div class="top-bar">
    <div class="left-buttons">
      <button>Clone</button>
      <button>Cancel</button>
    </div>
    <div class="editor-nav-panel">
      <button class="editor-nav" id="editor-publish">Publish</button>
    </div>
    <div class="editor-progress">
      <a href="<c:url value="/editor/anls/${anls.guid }/edit" />" class="editor-step editor-code-link">Code</a>
      <a href="<c:url value="/editor/anls/${anls.guid }/size" />" class="editor-step editor-size-link">Size</a>
      <a href="<c:url value="/editor/anls/${anls.guid }/describe" />" class="editor-step editor-describe-link">Describe</a>
    </div>
  </div>
  <div class="clear-bar"></div>
  <div class="editor-container">
    <div class="info-area">
      <h3 class="title">${anls.name }</h3>
      <div class="author">
        <img src="<c:url value="/resources/images/no-avatar.png" />" class="author-avatar" />
        <p class="author-name"><strong>${anls.user.username }</strong></p>
      </div>
      <div class="editor-status">
        <div class="saving-status">Automatically saved at 4:25 pm</div>
      </div>
    </div>
    <div class="clear"></div>
    <div class="detail-area">
      
    </div>
  </div>
</div>
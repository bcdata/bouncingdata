<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script type="text/javascript">
  com.bouncingdata.Main.loadCss(ctx + "/resources/css/bouncingdata/editor.css", "editor");

  var anls = {
    guid: '${anls.guid}',
    name: '${anls.name}',
    description: '${anls.description}',
    user: {username: '${anls.user.username}'},
    language: '${anls.language}',
  };
  
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
  <div class="editor-describe-container">
    <div class="detail-area" style="padding: 10px;">
      <form class="detail-form" method="post" action="">
        <fieldset style="border: 0 none;">
          <label for="name">Analysis name</label>
          <input type="text" name="name" id="name"><br/>
          <label for="description">Description</label>
          <textarea name="description" id="description" style="width: 100%; height: 300px;"></textarea> <br/>
          <input type="submit" value="Submit">
        </fieldset>
      </form>
      <div class="tag-set">
        <div class="tag-list">
          <a class="tag-element" href="javascript:void(0);">Football</a>
          <a class="tag-element" href="javascript:void(0);">Money</a>
          <a class="tag-element" href="javascript:void(0);">Madrid</a>
        </div>
        <a class="add-tag-button>" href="javascript:void()">
          Add tag
        </a>
      </div>
    </div>
  </div>
</div>
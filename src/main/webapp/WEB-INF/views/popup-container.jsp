<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="popup new-dialog" id="new-dialog" title="Create new script">
  <div class="entity-chooser">
    <span>Create new analysis, scraper or upload dataset</span>

    <div class="entity-list">
      <a class="new-anls" href="javascript:void(0)">Analysis</a>
      <a class="new-scraper" href="javascript:void(0)">Scraper</a>
      <a class="upload-data" href="javascript:void(0)">Upload dataset</a>
    </div>
  </div>
  <div class="new-script-wrapper">
    <form id="new-script-form" class="new-script-form" action="">
      <fieldset>
        <div>
          <label for="script-type">Type</label>
          <select name="type" id="script-type">
            <option value="analysis">Analysis</option>
            <option value="scraper">Scraper</option>
          </select>
        </div>
        <div>
          <label for="script-name">Name</label>
          <input type="text" id="script-name" name="name" maxlength="100"/>
        </div>
        <div>
          <label for="script-language">Language</label>
          <select name="language" id="script-language">
            <option value="r">R</option>
            <option value="python">Python</option>
          </select>
        </div>
        <div>
          <label>Privacy</label>
          <span>
            <span>Public&nbsp;</span><input type="radio" name="script-privacy" value="public" id="script-privacy-public" checked="checked"/>
            <span>Private&nbsp;</span><input type="radio" name="script-privacy" value="private" id="script-privacy-private"/>
          </span>
        </div>
      </fieldset>
    </form>
  </div>
  <!--div class="upload-data-wrapper">
    <form id="upload-data-form" method="POST" enctype="multipart/form-data">
      <fieldset>
        <label>Select your file</label> &nbsp;
        <input id="file" name="file" type="file"/> &nbsp;
      </fieldset>
      <img alt="Uploading" src="<c:url value="/resources/images/loader32.gif" />" class="upload-in-progress" />&nbsp;
      <span class="upload-status"></span>
    </form>
  </div-->
</div>

<div class="popup upload-data-dialog" id="upload-data-dialog" title="Upload data">
  <form id="file-upload-form" method="POST" enctype="multipart/form-data">
    <fieldset>
      <label>Select your file</label> &nbsp;
      <input id="file" name="file" type="file" /> &nbsp;
    </fieldset>
    <img alt="Uploading" src="<c:url value="/resources/images/loader32.gif" />" class="upload-in-progress" />&nbsp;
    <span class="upload-status"></span>
  </form>
  <div class="preview-panel" style="margin-top: 20px;">
    <div>
      <label>Dataset name</label>
      <input type="text" class="dataset-name" />
    </div>
    <div class="clear"></div>
    <table id="schema-table" class="schema-table" border="1" style="width: 100%; margin-top: 10px;">
      <thead>
        <tr>
          <td><strong>No.</strong></td>
          <td><strong>Column name</strong></td>
          <td><strong>Data type</strong></td>
        </tr>
      </thead>
      <tbody>

      </tbody>
    </table>
  </div>
</div>

<div class="popup publish-dialog" id="publish-dialog" title="Publish your visualization">
  <div class="preview-pane">
    <!--Preview visualization/data-->
  </div>
  <form class="publish-form">
    <fieldset>
      <div>
        <label>Visualization</label>
        <span><strong class="title"></strong></span>
      </div>
      <div>
        <label>Your message</label>
        <textarea class="publish-message"></textarea>
      </div>
    </fieldset>
  </form>

</div>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="header-content">
  <div class="header-login">
    <sec:authorize access="isAuthenticated()">
      <div>Welcome back <span style="font-weight: bold;"> 
          <sec:authentication property="principal.username" />
        </span>
        <a style="color: blue;" href="<c:url value="/auth/j_spring_security_logout" />"> Logout</a>
      </div>
    </sec:authorize>
  </div>
  
  <h2 class="header-logo">
    <a href="<c:url value="/"/>">Bouncing Data</a>
  </h2>
  <div class="top-page-panel">
    <div class="search-container">
      <form id="search-form" class="search-form" method="get">
        <div class="search-input-wrapper">
          <input type="text" class="search-input" id="query" name="query" />
        </div>
        <input type="hidden" name="criteria" value="global" id="criteria" />
        <!-- button type="submit" id="search-submit">Search</button-->
      </form>
    </div>
    <div class="header-buttons">
      <div class="guide-button-container">
        <div class="guide-button">Learn</div>
        <div class="guide-button">Help</div>
        <div class="guide-button">Me</div>
      </div>
      <div class="create-button-container">
        <div id="create-button" class="create-button">
          <a id="create-button-link" class="create-button-link" href="javascript:void(0);">Create</a>
        </div>
        <div class="create-submenu" style="display: none;">
          <ul>
            <li>
              <a id="create-analysis" class="create-sub-item" href="javascript:void(0);">
                <span class="sub-item-icon"></span>
              Analysis
              </a>
            </li>
            <li><a id="create-dataset" class="create-sub-item" href="<c:url value="/dataset/upload" />"><span class="sub-item-icon"></span>Dataset</a></li>
            <li><a id="create-scraper" class="create-sub-item" href="javascript:void(0);"><span class="sub-item-icon"></span>Scraper</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>
<jqtemplate>
  <!-- Comment templates -->
  <script id="comment-template" type="text/x-jquery-tmpl">
    <li class="comment-item" id="comment-\${id}" nodeid="\${id}">
      <div class="comment-item-body">
        <div class="comment-header">
          <div class="comment-author">\${username}</div>
        </div>
        <div class="comment-message">\${message}</div>
        <div class="comment-footer">
          <span class="comment-date">\${date}</span>&nbsp;
          <strong><span class="comment-score">\${upVote - downVote}</span>&nbsp;</strong>
          <!--span class="up-vote">\${upVote}</span>&nbsp;-->
          <a class="up-vote-link" href="#"><span class="up-vote-icon">Vote up</span></a>&nbsp;
          <!--span class="down-vote">\${downVote}</span>&nbsp;-->
          <a class="down-vote-link" href="#"><span class="down-vote-icon">Vote down</span></a>&nbsp;
          <a class="comment-reply" href="#">Reply</a>
        </div>
      </div>
      <ul class="children"></ul>
    </li>
	</script>
  <script id="comment-editor-template" type="text/x-jquery-tmpl">
    <div class="comment-editor inline-editor">
      <textarea class="reply-text" rows="\${rows}" spellcheck='false'></textarea>
      <input class="reply-button" type="button" value="Reply" />
      <div class="clear"></div>
    </div>
	</script>
  
  <!-- Dataset view templates  -->
  <script id="data-view-template" type="text/x-jquery-tmpl">
    <div class="dataset-view-container">
      <div class="dataset-view-layout" id="dataset-view-layout-\${tabId}">
        <div class="dataset-view-center" id="dataset-view-center-\${tabId}">
          <div class="dataset-view-main">
            <div class="dataset-view">
              <table class="dataset-table"></table>
            </div>
            <div class="dataset-query">
              <div class="dataset-query-editor">
                <textarea rows="5" class="code-editor query-editor" spellcheck="false"></textarea>
              </div>
              <div class="dataset-query-actions">
                <img id="ajax-loading" width="20px" height="20px" src="<c:url value="/resources/images/ajax-loading.gif" />" style="display:none;"  />
                <span id="ajax-message" style="color: Green; font-style: italic;"></span>
                <input class="dataset-query-execute" type="button" value="Execute" />
              </div>
            </div>
          </div>
        </div> 
        <div class="dataset-view-east" id="dataset-view-east-\${tabId}">
          <div class="dataset-view-side dataset-view-info">
            <p>
              <strong>Dataset: </strong>
              <span>\${dsName }</span>
            </p>
            <p>
              <strong>Author: </strong>
              <span>\${dsAuthor }</span>
            </p>
            <p>
              <strong>Schema: </strong>
              <span>\${dsSchema }</span>
            </p>
            <p>
              <strong>Row count: </strong>
              <span>\${dsRowCount }</span>
            </p>
            <p>
              <strong>Create date: </strong>
              <span>\${dsCreateDate }</span>
            </p>
            <p>
              <strong>Last update: </strong>
              <span>\${dsLastUpdate }</span>
            </p>
            <p>
              <strong>Tags: </strong>
              <span>\${dsTags }</span>
            </p>
          </div>
        </div>
      </div>    
    </div>
  </script>

  <script id="workbench-flow-template" type="text/x-jquery-tmpl">
    <div class="workbench-flow">
      <div class="app-info">
        <div class='app-title'><label style='font-weight: bold;'>Name: </label>\${appName}</div>
        <div class='app-language'><label style='font-weight: bold;'>Language: </label>\${appLang}</div>
      </div>
      <div class="workbench-flow-nav">
        <div class="flow-nav-item">
          <a href="javascript:void(0)" class="flow-nav-editor">Code</a>
        </div>
        <div class="flow-nav-item">
          <a href="javascript:void(0)" class="flow-nav-viz">Visualization</a>
        </div>
      </div>
      <div class="workbench-flow-content">
        <div class="workbench-editor">
          <div class="app-actions">
            <button id="app-execute-button-\${tabId}" class="app-action-button app-execute-button" title="Execute">Execute</button>
            <button id="app-view-viz-\${tabId}" class="app-action-button app-view-viz-button" title="View visualization">Visualization</button>
          </div>
          <div class="app-status">
            <img id="ajax-loading" width="20px" height="20px" src="<c:url value="/resources/images/ajax-loader.gif" />" style="opacity: 0;"  />
            <span id="ajax-message" style="color: Green; font-style: italic;"></span>
            <div class="saving-status">*</div>
          </div>
          <div class="code-editor-wrapper">
            <div>
              <div id="code-editor-\${tabId}" class="code-editor"></div>
            </div>
          </div>
          <div class="execution-logs-wrapper">
            <div id="execution-logs-\${tabId}" class="execution-logs">
              <div class="console prompt" style="display: block;"></div>
              <div class="console-actions">
                <input class="clear-console" type="button" value="Clear console" />
              </div>
            </div>
          </div>
        </div>
        <div class="workbench-result">
          <div class="app-actions">
            <button id="app-post-button-\${tabId}" class="app-action-button app-post-button" title="Post">Publish</button>
            <button id="app-back-button-\${tabId}" class="app-action-button app-back-button" title="Back">Back</button>
          </div>
          <div class="result-tabs output-tabs" id="\${tabId}-result-tabs">
            <ul>
              <li><a href="#\${tabId}-viz">Visualization</a></li>
              <li><a href="#\${tabId}-data">Data</a></li>
              <li><a href="#\${tabId}-code">Code</a></li>
            </ul>
            <div class="clear"></div>
            <div class="result-tab-viz ui-tabs-hide" id="\${tabId}-viz">
              <div><strong>Visualization Dashboard.</strong></div><br />
                <div class="viz-wrapper">
                  <div class="dashboard-ruler">
                    <div class="dashboard-ruler-left ruler"></div>
                    <div class="dashboard-ruler-top ruler"></div>
                    <div class="dashboard-ruler-right ruler"></div>
                    <div class="dashboard-ruler-bottom ruler"></div>
                    <div class="snap-line-left snap-line"></div>
                    <div class="snap-line-top snap-line"></div>
                    <div class="snap-line-right snap-line"></div>
                    <div class="snap-line-bottom snap-line"></div>
                  </div>
                  <div id="dashboard-wrapper-\${tabId}" class="dashboard-wrapper" style="width: 800px;position: absolute; visibility: hidden; height: 14000px;"></div>
                  <div class="viz-dashboard" id="viz-dashboard-\${tabId}"></div>
              </div>
            </div>
            <div class="result-tab-code ui-tabs-hide" id="\${tabId}-code">
              <div class="code-block">
                <pre class="brush: py"></pre>
              </div>
            </div>
            <div class="result-tab-data ui-tabs-hide" id="\${tabId}-data">
              <span class="no-data">No data</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </script>
  
  <script id="workbench-content-template" type="text/x-jquery-tmpl">
    <div class="workbench-ide-content">
        <div class="app-info">
          <div class='app-title'><label style='font-weight: bold;'>Application name: </label>\${appName}</div>
          <div class='app-language' id='app-language'><label style='font-weight: bold;'>Language: </label>\${appLang}</div>
          <div class='app-author'><label style='font-weight: bold;'>Author: </label>\${appAuthor}</div>
        </div>
        <div class="new-app-info">
          <strong>Language: </strong>
          <select class="language-select">
            <option value='python'>Python</option>
            <option value='r'>R</option>
          </select>
        </div>
        <div class="app-status">
          <img id="ajax-loading" width="20px" height="20px" src="<c:url value="/resources/images/ajax-loader.gif" />" style="opacity: 0;"  />
          <span id="ajax-message" style="color: Green; font-style: italic;"></span>
        </div>

        <div class="app-actions">
          <button id="app-execute-button-\${tabId}" class="app-action-button app-execute-button" title="Execute">Execute</button>
          <button id="app-post-button-\${tabId}" class="app-action-button app-post-button" title="Post">Post</button>
          <button id="app-back-to-code-button-\${tabId}" class="app-action-button app-back-to-code-button" title="Back">Back</button>
        </div>
        <div class="clear"></div>
        <div class="app-editor-container app-editor-tabs ui-tabs">
          <ul>
            <li><a href="#\${tabId}-code">Code</a></li>
            <li><a href="#\${tabId}-viz">Visualization</a></li>
            <li><a href="#\${tabId}-data">Data</a></li>
          </ul>
          
          <div class="app-code ui-tabs-hide" id="\${tabId}-code">
            <div class="app-code-editor">
              <div>
                <div id="code-editor-\${tabId}" class="code-editor"></div>
              </div>    
            </div>
            <div class="execution-logs-wrapper">
              <div id="execution-logs-\${tabId}" class="execution-logs">
                <div class="console prompt" style="display: block;"></div>
                <div class="console-actions">
                  <input class="clear-console" type="button" value="Clear console" />
                </div>
              </div>
            </div>
          </div>
          <div class="app-viz ui-tabs-hide" id="\${tabId}-viz">
            <div><strong>Visualization Dashboard.</strong></div><br />
            <div class="app-viz-dashboard">
              <div class="dashboard-ruler">
                <div class="dashboard-ruler-left ruler"></div>
                <div class="dashboard-ruler-top ruler"></div>
                <div class="dashboard-ruler-right ruler"></div>
                <div class="dashboard-ruler-bottom ruler"></div>
                <div class="snap-line-left snap-line"></div>
                <div class="snap-line-top snap-line"></div>
                <div class="snap-line-right snap-line"></div>
                <div class="snap-line-bottom snap-line"></div>
              </div>
              <div id="dashboard-wrapper-\${tabId}" class="dashboard-wrapper" style="width: 800px;position: absolute; visibility: hidden; height: 14000px;"></div>
              <div class="viz-dashboard" id="viz-dashboard-\${tabId}"></div>
            </div>
          </div>
          <div class="app-data ui-tabs-hide" id="\${tabId}-data">
            <span class="no-data">No data</span>
          </div>
        </div>
    </div>
  </script>    
  
  <script id="browser-item-template" type="text/x-jquery-tmpl">
    <div class="browser-item">
      <div class="browser-item-header">
        <a href="#"><span class="browser-item-title"><strong>\${title}</strong></span></a>
      </div>
      <div class="browser-item-footer">
        <a class="browser-item-footer-link expand-link" href="javascript:void(0);">Expand</a>
        <a class="browser-item-footer-link browser-item-action open-link" href="javascript:void(0)">Open</a>
      </div>
      <div class="browser-item-detail">
        <div class="browser-item-description browser-item-info">
          <strong>Description: </strong><span>\${description }</span>
        </div>
        <div class="browser-item-info application-language"><strong>Language: </strong>\${language}</div>
        <div class="browser-item-info"><strong>Author: </strong>\${author }</div>
        <div class="browser-item-info line-count"><strong>Line count: </strong>\${lineCount }</div>
        <div class="browser-item-info"><strong>Is public: </strong>\${public }</div>
        <div class="browser-item-info"><strong>Create date: </strong>\${createDate }</div>
        <div class="browser-item-info"><strong>Last update: </strong>\${lastUpdate }</div>
        <div class="browser-item-info browser-item-tags"><strong>Tags: </strong>\${tags }</div>
      </div>
  	</div>
  </script>
  
  <script id="feed-item-template_old" type="text/x-jquery-tmpl">
    <div class="event stream-item" aid="\${id }">
      <div class="event-avatar">
        <img class="avatar no-avatar" src="<c:url value="/resources/images/no-avatar.jpg" />">
      </div>
      <div class="event-content">
        <div class="info" aid="\${id }">
          <a href="#" class="user"><strong>\${username }</strong></a>&nbsp;
          <span class="action">\${action }</span>
          <div class="time">\${time}</div> 
        </div>
        <div class="thumbnail">
          <a id="evt-thumb-\${id }" href="<c:url value="/anls/\${guid}" />">
          	<img class="thumb-img" src="<c:url value="/thumbnails/\${thumbnail}.jpg" />" onerror="this.src='<c:url value="/thumbnails/no-image.jpg" />'; this.onerror=null;" />
          </a>
        </div>
        <p class="title">
          <a id="evt-title-\${id }" href="<c:url value="/anls/\${guid}" />"><strong>\${name}</strong></a>
        </p>
        <p class="description">
          <span>\${description }</span>
        </p>
        <div class="clear"></div>
        <div class="event-footer">
            <strong class="event-score">\${score }</strong>    
          &nbsp;<a id="evt-comment-\${id }" class="comments-link" href="<c:url value="/anls/\${guid}#comments" />"><strong>\${commentCount }</strong>&nbsp;comments</a>
        </div>
      </div>
      <div class="clear"></div>
    </div>
  </script>
  <script id="feed-item-template_old" type="text/x-jquery-tmpl">  
    <div class="event stream-item" aid=\${id }>
      <div class="event-content">
        <a class="event-avatar-link"> <img class="avatar no-avatar"
          src="<c:url value="/resources/images/no-avatar.png" />">
        </a>
        <div class="thumbnail">
          <a href="<c:url value="/anls/\${guid}" />">
            <img class="thumb-img" src="<c:url value="/thumbnails/\${thumbnail}.jpg" />"
              onerror="this.src='<c:url value="/thumbnails/no-image.jpg" />'; this.onerror=null;" />
          </a>
        </div>
        <p class="title">
          <a id="evt-title-\${id }" href="<c:url value="/anls/\${guid}" />"><strong>\${name}</strong></a>
        </p>
        <p class="info">
          <span class="author">Author: <a href="#">\${username}</a></span><br /> 
          <span class="tag-list">Tags:&nbsp;          
          </span>
        </p>
        <p class="description">
          <span>\${description }</span>
        </p>   
        <div class="clear"></div>
        <div class="event-footer">
          <strong class="event-score">\${score}</strong>&nbsp;
          <a id="evt-comment-\${id }" class="comments-link" href="<c:url value="/anls/\${guid}#comments" />"><strong>\${commentCount}</strong>&nbsp;comments</a>
        </div>
      </div>
      <div class="clear"></div>
    </div>
  </script>
</jqtemplate>
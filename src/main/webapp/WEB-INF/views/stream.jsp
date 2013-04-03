<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
  //com.bouncingdata.Main.loadCss(ctx + "/resources/css/bouncingdata/home.css", "home");
  com.bouncingdata.ActivityStream.init();
</script>
<div id="main-content" class="homepage-container">
  <div class="right-content">
    <div class="right-content-section most-popular-section">
      <h4 class="right-section-title">Most Popular</h4>
      <div class="most-popular-content right-section-tabs-wrapper">
        <div id="most-popular-content-tabs" class="most-popular-content-tabs ui-tabs">
          <ul>
            <li><a href="#most-popular-analysis">Analysis</a></li>
            <li><a href="#most-popular-dataset">Dataset</a></li>
          </ul>
          <div class="side-list-panel ui-tabs-hide" id="most-popular-analysis">
            <c:forEach items="${topAnalyses }" var="anls">
              <div class="side-item-panel">
                <a class="small-avatar-link"> 
                  <img class="avatar no-avatar" src="<c:url value="/resources/images/no-avatar.png" />">
                </a>
                <div class="small-thumbnail">
                  <a href="<c:url value="/anls/${anls.guid}" />"> 
                    <c:choose>
                      <c:when test="${not empty anls.thumbnail }">
                        <img class="thumb-img" src="<c:url value="/thumbnails/${anls.thumbnail}.jpg" />" onerror="this.src='<c:url value="/thumbnails/no-image.jpg" />'; this.onerror=null;" />
                      </c:when>
                      <c:otherwise>
                        <img class="thumb-img" src="<c:url value="/thumbnails/no-image.jpg" />" />
                      </c:otherwise>
                    </c:choose>
                  </a>
                </div>
                <p class="side-item-title">
                  <a href="<c:url value="/anls/${anls.guid}" />"><strong>${anls.name}</strong></a>
                </p>
                <p class="side-item-author">
                  <span>by <a href="#">${anls.user.username }</a></span>
                </p>
                <div class="clear"></div>
              </div>
            </c:forEach>
          </div>
          <div class="side-list-panel ui-tabs-hide" id="most-popular-dataset">
            <c:forEach items="${topDatasets }" var="dts">
              <div class="side-item-panel">
                <a class="small-avatar-link"> 
                  <img class="avatar no-avatar" src="<c:url value="/resources/images/no-avatar.png" />">
                </a>
                <div class="small-thumbnail">
                  <a href="<c:url value="/dataset/view/${dts.guid}" />">
                    <img class="thumb-img" src="<c:url value="/thumbnails/no-image.jpg" />" />
                  </a>
                </div>
                <p class="side-item-title">
                  <a href="<c:url value="/dataset/view/${dts.guid}" />"><strong>${dts.name}</strong></a>
                </p>
                <p class="side-item-author">
                  <span>by ${dts.user.username }</span>
                </p>
                <div class="clear"></div>
              </div>
            </c:forEach>
          </div>
        </div>
      </div>
    </div>
    <div class="right-content-section recommendation-section">
      <h4 class="right-section-title">Staff's Pick</h4>    
      <div class="staff-pick-content right-section-tabs-wrapper">
        <div id="staff-pick-content-tabs" class="staff-pick-content-tabs ui-tabs">
          <ul>
            <li><a href="#staff-pick-analysis">Analysis</a></li>
            <li><a href="#staff-pick-dataset">Dataset</a></li>
          </ul>
          <div class="side-list-panel ui-tabs-hide" id="staff-pick-analysis">
            <c:forEach items="${topAnalyses }" var="anls">
              <div class="side-item-panel">
                <a class="small-avatar-link">
                  <img class="avatar no-avatar" src="<c:url value="/resources/images/no-avatar.png" />">
                </a>
                <div class="small-thumbnail">
                  <a href="<c:url value="/anls/${anls.guid}" />">
                    <c:choose>
                      <c:when test="${not empty anls.thumbnail }">
                        <img class="thumb-img" src="<c:url value="/thumbnails/${anls.thumbnail}.jpg" />" onerror="this.src='<c:url value="/thumbnails/no-image.jpg" />'; this.onerror=null;" />
                      </c:when>
                      <c:otherwise>
                        <img class="thumb-img" src="<c:url value="/thumbnails/no-image.jpg" />" />
                      </c:otherwise>
                    </c:choose>
                  </a>
                </div>
                <p class="side-item-title">
                  <a href="<c:url value="/anls/${anls.guid}" />"><strong>${anls.name}</strong></a>
                </p>
                <p class="side-item-author">
                  <span>by ${anls.user.username }</span>
                </p>
                <div class="clear"></div>
              </div>
            </c:forEach>
          </div>
          <div class="side-list-panel ui-tabs-hide"  id="staff-pick-dataset">
            <c:forEach items="${topDatasets }" var="dts">
              <div class="side-item-panel">
                <a class="small-avatar-link">
                  <img class="avatar no-avatar" src="<c:url value="/resources/images/no-avatar.png" />">
                </a>
                <div class="small-thumbnail">
                  <a href="<c:url value="/dataset/view/${dts.guid}" />">
                    <img class="thumb-img" src="<c:url value="/thumbnails/no-image.jpg" />" />
                  </a>
                </div>
                <p class="side-item-title">
                  <a href="<c:url value="/dataset/view/${dts.guid}" />"><strong>${dts.name}</strong></a>
                </p>
                <p class="side-item-author">
                  <span>by ${dts.user.username }</span>
                </p>
                <div class="clear"></div>
              </div>
            </c:forEach>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="center-content">
    <div class="center-content-wrapper">
      <div class="stream-container center-content-main">
        <div class="stream-filter">
          <span class="" style="float: left;">
            <a href="#">All</a>&nbsp;&nbsp;|
            <a href="#">Analysis</a>&nbsp;&nbsp;|
            <a href="#">Dataset</a>
          </span>
          <span style="float: right;">
            <a href="#">Recent</a>&nbsp;&nbsp;|
            <a href="#">Popular</a>
          </span>
        </div>
        <div class="clear"></div>
        <div class="stream main-activity-stream" id="stream">
          <c:if test="${not empty recentAnalyses }">
            <c:forEach items="${recentAnalyses }" var="anls">         
              <div class="event stream-item" aid=${anls.id }>
                <div class="event-content">
                  <!-- div class="info" aid="${activity.id }">
                    <a href="#" class="user"><strong>${activity.user.username }</strong></a>&nbsp;
                    <span class="action">${activity.action }</span>
                    <div class="time">${activity.time}</div> 
                  </div-->
                  <a class="event-avatar-link">
                    <img class="avatar no-avatar" src="<c:url value="/resources/images/no-avatar.png" />">
                  </a>
                  <div class="thumbnail">
                    <a href="<c:url value="/anls/${anls.guid}" />">
                      <c:choose>
                        <c:when test="${not empty anls.thumbnail }">
                          <img class="thumb-img" src="<c:url value="/thumbnails/${anls.thumbnail}.jpg" />" onerror="this.src='<c:url value="/thumbnails/no-image.jpg" />'; this.onerror=null;" />
                        </c:when>
                        <c:otherwise>
                          <img class="thumb-img" src="<c:url value="/thumbnails/no-image.jpg" />" />
                        </c:otherwise>
                      </c:choose>
                    </a>
                  </div>
                  <p class="title">
                    <a id="evt-title-${anls.id }" href="<c:url value="/anls/${anls.guid}" />"><strong>${anls.name}</strong></a>
                  </p>
                  <p class="info">
                    <span class="author">Author: <a href="#">${anls.user.username }</a></span><br/>
                    <span class="tag-list">Tags:&nbsp; 
                      <c:if test="${not empty anls.tags }">
                        <c:forEach var="tag" items="${anls.tags }">
                          <div class="tag-element-outer">
                            <a class="tag-element" href="<c:url value="/tag/${tag.tag }" />">${tag.tag }</a>
                          </div>
                        </c:forEach>
                      </c:if>
                    </span>
                  </p>
                  <p class="description">
                    <span>${anls.description }</span>
                  </p>
                  
                  <div class="clear"></div>
                  <div class="event-footer">
                    <c:if test="${anls.score > 0}">
                      <strong class="event-score event-score-positive">+${anls.score }</strong>    
                    </c:if>
                    <c:if test="${anls.score == 0}">
                      <strong class="event-score">0</strong>    
                    </c:if>
                    <c:if test="${anls.score < 0}">
                      <strong class="event-score event-score-negative">${anls.score }</strong>    
                    </c:if>
                    &nbsp;<a id="evt-comment-${anls.id }" class="comments-link" href="<c:url value="/anls/${anls.guid}#comments" />"><strong>${anls.commentCount }</strong>&nbsp;comments</a>
                  </div>
                </div>
                <div class="clear"></div>
              </div>
            
            </c:forEach>
          </c:if>      
          <div class="stream-footer">
            <a href="javascript:void(0);" class="more-feed">More</a> &nbsp;&nbsp;
            <img style="display: none;" class="feed-loading" src="<c:url value="/resources/images/loader32.gif" />" />
          </div>    
        </div>
      </div>
    </div>
  </div>
</div>
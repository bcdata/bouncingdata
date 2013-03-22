<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
  //com.bouncingdata.Main.loadCss(ctx + "/resources/css/bouncingdata/home.css", "home");
  com.bouncingdata.ActivityStream.init();
</script>
<div id="main-content" class="homepage-container">
  <div class="right-content" style="color: #555555;">
    <div class="right-content-section most-popular-section">
      <div class="right-content-section-title">
        <h4>Most Popular</h4>   
        <div class="most-popular-content">
          <div id="most-popular-content-tabs" class="most-popular-content-tabs">
            <ul>
              <li><a href="#most-popular-analysis">Analysis</a></li>
              <li><a href="#most-popular-dataset">Dataset</a></li>
            </ul>
            <div class="side-list-panel" id="most-popular-analysis">
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
            <div class="side-list-panel" id="most-popular-dataset">
              <c:forEach items="${topDatasets }" var="dts">
                <div class="side-item-panel">
                  <a class="small-avatar-link">
                    <img class="avatar no-avatar" src="<c:url value="/resources/images/no-avatar.png" />">
                  </a>
                  <div class="small-thumbnail">
                    <a href="<c:url value="/dataset/${dts.guid}" />">
                      <img class="thumb-img" src="<c:url value="/thumbnails/no-image.jpg" />" />
                    </a>
                  </div>
                  <p class="side-item-title">
                    <a href="<c:url value="/dataset/${dts.guid}" />"><strong>${dts.name}</strong></a>
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
    <div class="right-content-section recommendation-section">
      <div class="right-content-section-title">
        <h4>Staff's Pick</h4>    
        <div class="staff-pick-content">
          <div id="staff-pick-content-tabs">
            <ul>
              <li><a href="#staff-pick-analysis">Analysis</a></li>
              <li><a href="#staff-pick-dataset">Dataset</a></li>
            </ul>
            <div class="side-list-panel" id="staff-pick-analysis">
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
            <div class="side-list-panel" id="staff-pick-dataset">
              <c:forEach items="${topDatasets }" var="dts">
                <div class="side-item-panel">
                  <a class="small-avatar-link">
                    <img class="avatar no-avatar" src="<c:url value="/resources/images/no-avatar.png" />">
                  </a>
                  <div class="small-thumbnail">
                    <a href="<c:url value="/dataset/${dts.guid}" />">
                      <img class="thumb-img" src="<c:url value="/thumbnails/no-image.jpg" />" />
                    </a>
                  </div>
                  <p class="side-item-title">
                    <a href="<c:url value="/dataset/${dts.guid}" />"><strong>${dts.name}</strong></a>
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
  </div>
  <div class="center-content">
    <div class="center-content-wrapper">
      <div class="stream-container center-content-main">
        <h3>Activity stream</h3>
        <div class="stream main-activity-stream" id="stream">
          <c:forEach items="${activities }" var="activity">
            <c:if test="${not empty activity.object }">
              <div class="event stream-item" aid="${activity.id }">
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
                    <a id="evt-thumb-${activity.id }" href="<c:url value="/anls/${activity.object.guid}" />">
                      <c:choose>
                        <c:when test="${not empty activity.object.thumbnail }">
                          <img class="thumb-img" src="<c:url value="/thumbnails/${activity.object.thumbnail}.jpg" />" onerror="this.src='<c:url value="/thumbnails/no-image.jpg" />'; this.onerror=null;" />
                        </c:when>
                        <c:otherwise>
                          <img class="thumb-img" src="<c:url value="/thumbnails/no-image.jpg" />" />
                        </c:otherwise>
                      </c:choose>
                    </a>
                  </div>
                  <p class="title">
                    <a id="evt-title-${activity.id }" href="<c:url value="/anls/${activity.object.guid}" />"><strong>${activity.object.name}</strong></a>
                  </p>
                  <p class="info">
                    <span class="author">Author: <a href="#">${activity.user.username }</a></span><br/>
                    <span class="tag-list">Tags:&nbsp; 
                      <c:if test="${not empty activity.object.tags }">
                        <c:forEach var="tag" items="${activity.object.tags }">
                          <a class="tag-element" href="<c:url value="/tag/${tag.tag }" />">${tag.tag }</a>
                        </c:forEach>
                      </c:if>
                      <!-- a class="tag-element" href="javascript:void(0);">Football</a>
                      <a class="tag-element" href="javascript:void(0);">Money</a>
                      <a class="tag-element" href="javascript:void(0);">Madrid</a-->
                    </span>
                  </p>
                  <p class="description">
                    <span>${activity.object.description }</span>
                  </p>
                  
                  <div class="clear"></div>
                  <div class="event-footer">
                    <c:if test="${activity.object.score > 0}">
                      <strong class="event-score event-score-positive">+${activity.object.score }</strong>    
                    </c:if>
                    <c:if test="${activity.object.score == 0}">
                      <strong class="event-score">0</strong>    
                    </c:if>
                    <c:if test="${activity.object.score < 0}">
                      <strong class="event-score event-score-negative">${activity.object.score }</strong>    
                    </c:if>
                    &nbsp;<a id="evt-comment-${activity.id }" class="comments-link" href="<c:url value="/anls/${activity.object.guid}#comments" />"><strong>${activity.object.commentCount }</strong>&nbsp;comments</a>
                  </div>
                </div>
                <div class="clear"></div>
              </div>
            </c:if>
          </c:forEach>      
          <div class="stream-footer">
            <a href="javascript:void(0);" class="more-feed">More</a> &nbsp;&nbsp;
            <img style="display: none;" class="feed-loading" src="<c:url value="/resources/images/loader32.gif" />" />
          </div>    
        </div>
      </div>
    </div>
  </div>
</div>
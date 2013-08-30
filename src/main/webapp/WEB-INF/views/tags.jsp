<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
  com.bouncingdata.ActivityStream.init();
</script>
<div id="main-content" class="homepage-container">
  <div class="right-content">
   <div class="rsection">
	  <div class="most-popular-section">Most popular</div>
	  <div class="most-popular-items">
	  		<c:forEach items="${topAnalyses }" varStatus="mpscount" var="mpanls">
		  		<div class="popular-item">
		  			<div class="popular-img-item" ><img src="<c:url value="/resources/images/shape-0${mpscount.count}.png" />" /></div>
		  			<div>
		  				<div class="popular-item-title">
		  					<a href="<c:url value="/anls/${mpanls.guid}" />" class="popular-item-link">${mpanls.name}</a>
		  				</div>
		  				<div class="popular-item-author">by <strong>${mpanls.user.username }</strong></div>
		  			</div>
		  		</div>
	  		</c:forEach>
	  		<div class="more-popular-item" >
	  			<a href="javascript:void(0);" class="popular-item-link">See more ...</a>
	  		</div>
	  </div>
  </div>
  
  <div class="rsection">
	  <div class="most-popular-section">Staff's Pick</div>
	    <!-- vinhpq : for ajax filter. Don't need reload page. --> 
	    <script type="text/javascript">
		$(document).ready(function() {
			$('#staff-pick-analysis-tab').click(function() {
				$('.popular-item-title .staff-pick-link').removeClass('active');
				$(this).addClass('active');		
				$('#staff-pick-analysis').show();	
				$('#staff-pick-dataset').hide();
				$('#staff-pick-scraper').hide();
				return false;
			});
			
			$('#staff-pick-dataset-tab').click(function() {
				$('.popular-item-title .staff-pick-link').removeClass('active');
				$(this).addClass('active');		
				$('#staff-pick-analysis').hide();	
				$('#staff-pick-dataset').show();
				$('#staff-pick-scraper').hide();
				return false;
			});
			
			$('#staff-pick-scraper-tab').click(function() {
				$('.popular-item-title .staff-pick-link').removeClass('active');
				$(this).addClass('active');		
				$('#staff-pick-analysis').hide();	
				$('#staff-pick-dataset').hide();
				$('#staff-pick-scraper').show();
				return false;
			});
			
		});
		</script>
	  <div class="most-popular-items">
	  		<div class="staff-pick-section" >
	  			<div>
	  				<div class="popular-item-title">
	   					<span id="staff-pick-analysis-tab" class="staff-pick-link active" >Analysis</span>
	   					<span id="staff-pick-dataset-tab" class="staff-pick-link" >Dataset</span>
	   					<span id="staff-pick-scraper-tab" class="staff-pick-link" >Scraper</span>
					</div>	  				
	  			</div>
	  		</div>
	  		
	  		<!-- Show analysis for staff pick -->
	  		<div id="staff-pick-analysis">
	  			<c:forEach items="${topAnalyses }" var="anls">
			  		<div class="popular-item">
			  			<div class="popular-img-item" ><img class="staff-pick-analysis-image" src="data:image/png;base64,${anls.thumbnail}" onerror="this.src='<c:url value="/thumbnails/no-image.jpg" />'; this.onerror=null;" /></div>
			  			<div>
			  				<div class="popular-item-title">
			  					<a href="<c:url value="/anls/${anls.guid}" />" class="popular-item-link">${anls.name}</a>
			  				</div>
			  				<div class="popular-item-author">by <strong>${anls.user.username }</strong></div>
			  				<div class="popular-item-author">Posted:30/10/2013 | 23 views</div>
			  			</div>
			  		</div>
		  		</c:forEach>
	  		</div>
	  		
	  		<!-- Show dataset for staff pick -->
	  		<div id="staff-pick-dataset">
		  		<c:forEach items="${topDatasets }" varStatus="dsStatus" var="dts">
			  		<div class="popular-item">
			  			<div class="popular-img-item" ><img src="<c:url value="/resources/images/shape-0${dsStatus.count}.png" />" /></div>
			  			<div>
			  				<div class="popular-item-title">
			  					<a href="<c:url value="/dataset/view/${dts.guid}" />" class="popular-item-link">${dts.name}</a>
			  				</div>
			  				<div class="popular-item-author">by <strong>${dts.user.username }</strong></div>
			  			</div>
			  		</div>
		  		</c:forEach>
	  		</div>
	  		
	  		<!-- Show scraper for staff pick -->
	  		<div id="staff-pick-scraper">
		  		
	  		</div>
	  		
	  		<div class="more-popular-item" >
	  			<a href="javascript:void(0);" class="popular-item-link">See more ...</a>
	  		</div>
	  </div>
  </div>
    <%-- <div class="right-content-section most-popular-section">
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
                  <span>by <a href="#">${dts.user.username }</a></span>
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
                  <span>by <a href="#">${anls.user.username }</a></span>
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
                  <span>by <a href="#">${dts.user.username }</a></span>
                </p>
                <div class="clear"></div>
              </div>
            </c:forEach>
          </div>
        </div>
      </div>
    </div> --%>
  </div>
  <div class="center-content">
    <div class="center-content-wrapper" style=" height: 900px; ">
      <div class="stream-container center-content-main">
        <div class="clear"></div>
        <div class="stream main-activity-stream" id="stream">
           <div class="event stream-item" aid=${anls.id }>
             <div class="event-content">
               <p class="info">
                 <c:if test="${not empty _tags }">
                   <c:forEach var="tag" items="${_tags }">
                     <div class="tag-element-outer">
                       <a class="tag-element" href="<c:url value="/tag/${tag.tag }" />">${tag.tag }</a>
                     </div>
                   </c:forEach>
                 </c:if>
               </p>
             </div>
             <div class="clear"></div>
           </div>
        </div>
      </div>
    </div>
  </div>
</div>
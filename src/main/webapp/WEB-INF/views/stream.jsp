<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
  //com.bouncingdata.Main.loadCss(ctx + "/resources/css/bouncingdata/home.css", "home");
  com.bouncingdata.ActivityStream.init();
</script>

<script>
$(function() {
	
	$( ".link-del-item" ).click(function() {
		$("#item-del-infor").attr("dvid",$(this).attr("dvid"));
		$("#item-del-infor").attr("iguid",$(this).attr("iguid"));
		$("#item-del-infor").attr("itype",$(this).attr("itype"));
		$("#item-del-infor").attr("iname",$(this).attr("iname"));
		
		$("#item-del-name").html("'<b style=\"color: royalblue;\">" + $(this).attr("iname") + "</b>'");
        $( "#dialog-confirm-delete" ).dialog( "open" );
    });
	
	$( "#dialog-confirm-delete" ).dialog({
	  autoOpen: false,
	  resizable: false,
	  height:'auto',
	  minHeight: 140,
      modal: true,
      buttons: {
        "Delete": function() {
      	  $("#progress-del-img").show();
      	  var dvid = $("#item-del-infor").attr("dvid");
      	  var iguid = $("#item-del-infor").attr("iguid");
      	  var itype = $("#item-del-infor").attr("itype");
      	  var iname = $("#item-del-infor").attr("iname");
      	  
      	  var url = '';
      	  debugger;
      	  if(itype=='Dataset')
      		  url = '<c:url value="/dataset/dels"/>';
          else if(itype=='Analysis')
        	  url = '<c:url value="/anls/dels"/>';
       	  else{
       		  window.alert("Cant find type of the item!");
	          return;
       	  }
      	  //process delete here 
      	  $.ajax({
				type : "post",
				url :   url,
				data : {
					"iguid" : iguid,
					"itype" : itype,
					"iname" : iname
				},
				success : function(res) {
					$( "#dialog-confirm-delete" ).dialog( "close" );
					$("#progress-del-img").hide();
					
					if (res['code'] < 0) {
						window.alert("Failed to delete!");
				        return;
					}else{
						$("div[aid='"+dvid+"']").remove();
					}
				}
			});
        },
        Cancel: function() {
          $( this ).dialog( "close" );
        }
      }
    });
});
</script>
<div id="main-content" class="homepage-container" >
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
                        <img class="thumb-img" src="data:image/png;base64,${anls.thumbnail}" onerror="this.src='<c:url value="/thumbnails/no-image.jpg" />'; this.onerror=null;" />
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
                        <img class="thumb-img" src="data:image/png;base64,${anls.thumbnail}" onerror="this.src='<c:url value="/thumbnails/no-image.jpg" />'; this.onerror=null;" />
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
  <div class="center-content" >
    <div class="center-content-wrapper" style="width: 100%;padding-left: 0px;">
    <!-- vinhpq : for ajax filter. Don't need reload page. 
    <script type="text/javascript">
	$(document).ready(function() {
		$('#filter-nav-top #filter-top-left a').click(function() {
			// fetch the class of the clicked item
			var ourClass = $(this).attr('fid');
			
			// reset the active class on all the buttons
			$('#filter-nav-top #filter-top-left a').removeClass('nav-selected');
			// update the active state on our clicked button
			$(this).addClass('nav-selected');
			
			if(ourClass == 'All') {
				// show all our items
				$('#stream').children('div.stream-item').show();	
			}
			else {
				// hide all elements that don't share ourClass
				$('#stream').children('div:not(.' + ourClass + ')').hide();
				// show all elements that do share ourClass
				$('#stream').children('div.' + ourClass).show();
			}
			return false;
		});
		
	});
	</script> -->
    
      <div class="stream-container center-content-main">
        <div class="stream-filter" id="filter-nav-top">
          <span id="filter-top-left" style="float: left;">
            <a href="<c:url value="/stream/${pageId}/all/${tp}" />" ${fm eq 'all'?'class="nav-selected"':''}>All</a>&nbsp;|&nbsp;
            <a href="<c:url value="/stream/${pageId}/analysis/${tp}" />" ${fm eq 'analysis'?'class="nav-selected"':''}>Analysis</a>&nbsp;|&nbsp;
            <a href="<c:url value="/stream/${pageId}/dataset/${tp}" />" ${fm eq 'dataset'?'class="nav-selected"':''}>Dataset</a>
            <%-- &nbsp;|&nbsp;
            <a href="<c:url value="/stream/${pageId}/scraper/${tp}" />" ${fm eq 'scraper'?'class="nav-selected"':''}>Scraper</a> --%>
          </span>
          <span id="filter-top-right" style="float: right;">
            <a href="<c:url value="/stream/${pageId}/${fm}/recent" />" ${tp eq 'recent'?'class="nav-selected"':''} >Recent</a>&nbsp;|&nbsp;
            <a href="<c:url value="/stream/${pageId}/${fm}/popular" />" ${tp eq 'popular'?'class="nav-selected"':''}>Popular</a>
          </span>
        </div>
        <div class="clear"></div>
        <div class="stream main-activity-stream" id="stream">
        <div class="container" id="box-container">
         <c:if test="${not empty recentAnalyses }">
            <c:forEach items="${recentAnalyses }" var="anls">
             	<c:choose>
					<c:when test="${anls.classType eq 'Analysis' }"> 
						<div class="box stream-item" >
			             <div class="article">
			             	<div class="article-content" id="dv_${anls.id}">
			             		  <c:if test="${not empty anls.thumbnail }">
			             		  	<img id="tbn_${anls.id}" class="thumbnail" onerror="this.src='<c:url value="/thumbnails/no-image.jpg" />'; this.onerror=null;" />
										<script type="text/javascript" >
			             		    var patt1 = /visualize\/app\/(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}\/(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}\/html/i;
										 if(patt1.test("${anls.thumbnail}")) {
											//Case of the html visualization
											$("#tbn_${anls.id}").css("display","none");
											var iFrameElement = $('<iframe style="width: 100%; height: 100%;" scrolling="no"></iframe>');
											iFrameElement.attr('src', ctx + '/' + "${anls.thumbnail}");
											$("#dv_${anls.id}").append(iFrameElement);
										 } else {
										 	//Case of the png visualization
										 	$("#tbn_${anls.id}").attr('src', "data:image/png;base64,${anls.thumbnail}");
										 }											
										</script>			             		  
			             		  </c:if>
				                  <h4><a id="evt-title-${anls.id }" href="<c:url value="/anls/${anls.guid}"/>">${anls.name}</a></h4>
				                  <span>
				                  		<c:if test="${anls.score > 0}">
					                      ${anls.score } like | 0 dislike
					                    </c:if>
					                    <c:if test="${anls.score == 0}">
					                      0 like | 0 dislike
					                    </c:if>
					                    <c:if test="${anls.score < 0}">
					                      0 like | ${anls.score } dislike    
					                    </c:if>
					                    | ${anls.commentCount } comments
				                 </span>
			                  </div>
			                  <div class="person-section">
			                  	<table>
			                  		<tr>
			                  			<td><img class="person-avatar" src="<c:url value="/resources/images/no-avatar.png" />" ></td>
			                  			<td>
			                  				<span><a href="javascript:void(0);" class="person-link-name">${anls.username }</a></span><br/>
			                  				<span><%= java.lang.Math.round(java.lang.Math.random() * 100) %> posted</span>
			                  			</td>
			                  		</tr>
			                  	</table>
						       </div>
				             </div>
				         </div>
					</c:when>
					
					<c:otherwise>
					
						<div class="box stream-item">
				             <div class="article">
				             <div class="article-content">
				                  <h4 class="article-dataset"><a id="evt-title-${anls.id}" href="<c:url value="/dataset/view/${anls.guid}" />">${anls.name}</a></h4>
				                  <span>
				                  		<c:if test="${anls.score > 0}">
					                      ${anls.score } like | 0 dislike
					                    </c:if>
					                    <c:if test="${anls.score == 0}">
					                      0 like | 0 dislike
					                    </c:if>
					                    <c:if test="${anls.score < 0}">
					                      0 like | ${anls.score } dislike    
					                    </c:if>
					                    | ${anls.commentCount } comments
				                 </span>
				             </div>
				                  <div class="person-section person-dataset">
				                  	<table>
				                  		<tr>
				                  			<td><img class="person-avatar" src="<c:url value="/resources/images/no-avatar.png" />" ></td>
				                  			<td>
				                  				<span><a href="javascript:void(0);" class="person-link-name">${anls.username }</a></span><br/>
				                  				<span><%= java.lang.Math.round(java.lang.Math.random() * 100) %> posted</span>
				                  			</td>
				                  		</tr>
				                  	</table>
							       </div>
				             </div>
				         </div>
					</c:otherwise>
				</c:choose>
            </c:forEach>
         </c:if>
      </div> 
          <%-- <c:if test="${not empty recentAnalyses }">
            <c:forEach items="${recentAnalyses }" var="anls">         
              
              <div class="event stream-item ${anls.classType}" aid=${anls.id}>
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
                    <a href="<c:choose>
								<c:when test="${anls.classType eq 'Analysis' }"> 
									<c:url value="/anls/${anls.guid}"/>
								</c:when>
								<c:otherwise><c:url value="/dataset/view/${anls.guid}" /></c:otherwise>
							</c:choose>">
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
                  	<!-- vinhpq : preview webpage on mouse over event (acitive func : adding in link class="popover") -->
                    <a id="evt-title-${anls.id }" href="
                    									<c:choose>
                											<c:when test="${anls.classType eq 'Analysis' }"> 
                												<c:url value="/anls/${anls.guid}"/>
                											</c:when>
                											<c:otherwise><c:url value="/dataset/view/${anls.guid}" /></c:otherwise>
                										</c:choose>" ><strong>${anls.name}</strong></a>
                  </p>
                  <div class="info">
                    <span class="author">Author: <a href="#">${anls.username }</a></span><br/>
                    <div class="tag-list">Tags:&nbsp; 
                      <c:if test="${not empty anls.tags }">
                        <c:forEach var="tag" items="${anls.tags }">
                          <div class="tag-element-outer">
                            <a class="tag-element" href="<c:url value="/tag/${tag.tag }" />">${tag.tag }</a>
                          </div>
                        </c:forEach>
                      </c:if>
                    </div>
                  </div>
                  <div class="description">
                    	<span>${anls.description}</span>
                  </div>
                  
                  <div class="clear"></div>
                  <div class="event-footer">
                  	<c:if test="${pageId eq 'streambyself'}">
                  		<c:if test="${anls.flag eq 'true'}">	
							<img src="<c:url value="/resources/images/icon-public.png" />" title="Public" class="publImage">
						</c:if>
					</c:if>
                  
                    <c:if test="${pageId eq 'streambyself'}">
						<c:if test="${anls.flag eq 'false'}">
							<img src="<c:url value="/resources/images/icon-private.png" />" title="Private" class="privImage">
						</c:if>
					</c:if> 
					
                    <c:if test="${anls.score > 0}">
                      <strong class="event-score event-score-positive">+${anls.score }</strong>    
                    </c:if>
                    <c:if test="${anls.score == 0}">
                      <strong class="event-score">0</strong>    
                    </c:if>
                    <c:if test="${anls.score < 0}">
                      <strong class="event-score event-score-negative">${anls.score }</strong>    
                    </c:if>
                    &nbsp;<a id="evt-comment-${anls.id }" class="comments-link" href="<c:choose>
                    																	<c:when test="${anls.classType eq 'Analysis' }"> 
                    																		<c:url value="/anls/${anls.guid}#comments" />
                    																  	</c:when>
                    																  	 <c:otherwise>#</c:otherwise>
                    																  </c:choose>">
                    																  		<strong>${anls.commentCount }</strong>&nbsp;comments</a>
					<c:if test="${pageId eq 'streambyself'}">
						<a href="javascript:void(0)" class="link-del-item" dvid="${anls.id }" iguid="${anls.guid}" itype="${anls.classType}" iname="${anls.name}">
							<img src="<c:url value="/resources/images/trash.png" />" style="width: 13px;" title="delete">
						</a>
					</c:if>                   																  		
                  </div>
                </div>
                <div class="clear"></div>
              </div>
            
            </c:forEach>
          </c:if>     --%>  
          
          
          <div class="stream-footer">
            <a href="javascript:void(0);" class="more-feed" pageid="${pageId}" fm="${fm}" tp="${tp}">More</a> &nbsp;&nbsp;
            <img style="display: none;" class="feed-loading" src="<c:url value="/resources/images/loader32.gif" />" />
          </div>    
        </div>
      
      </div>
    </div>
  </div>
</div>

<!-- vinhpq : popup delete item -->
<div id="dialog-confirm-delete" title="Delete item?" >
  <p><span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>The <font id="item-del-name"></font> item will be deleted and cannot be recovered. Are you sure?</p>
  <div id="progress-del-img" style="display:none">
	<img src="<c:url value="/resources/images/wait.gif" />" style="vertical-align: middle;height: 18px;width: 18px; margin-right: 3px;"> waiting...
  </div>
  <label id="item-del-infor"></label>
</div>
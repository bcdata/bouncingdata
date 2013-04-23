<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script>
	var dataset = {
      guid: '${dataset.guid}',
      user: '${dataset.user.username}',
      name: '${dataset.name}'
	};
	com.bouncingdata.Dataset.init(dataset);
</script>

<style>
	#q{
		width: 99%; padding: 0 0 0 5px;border: 0 none; height: 28px; outline: none; font-size: 12px;color: #9a9a9a;
	}
	#divQuery{
		border-color: rgb(77, 144, 254);float: left;width: 66%; border: 1px solid #DDD; height: 28px; padding: 0; display: inline-block; background-color: #FFFFFF;
	}
</style>
<div id="main-content" class="datapage-container">
  <div class="data-info right-content">
    <!-- div class="dataset-summary summary">
      <div class="data-info-header info-header">
        <div class="data-info-title info-title">Dataset Info</div>
        <div class="data-info-title-line info-title-line"></div>
      </div>
      <p class="line-item">
        <strong>Dataset: </strong><span>${dataset.name }</span>
      </p>
      <p class="line-item">
        <strong>Author: </strong><span>${dataset.user.username }</span>
      </p>
      <p class="line-item">
        <strong>Description: </strong><span>${dataset.description }</span>
      </p>
      <p class="line-item">
        <strong>Create at: </strong><span>${dataset.createAt }</span>
      </p>
      <p class="line-item">
        <strong>Tags: </strong><span>${dataset.tags }</span>
      </p>
    </div>
    <div class="related-info dataset-related-info">
      <div class="data-info-header info-header">
        <div class="data-info-title info-title">Related Info</div>
        <div class="data-info-title-line info-title-line"></div>
      </div>
      <c:if test="${not empty relatedAnls }">
        <p class="related-analyses">
          <strong>Related analyses: </strong>
          <c:forEach items="${relatedAnls }" var="anls">
            <a class="related-anls-link" href="<c:url value="/anls" />/${anls.guid}">${anls.name }</a>&nbsp;
          </c:forEach>
        </p>
        <script>
          $(function() {
            $('.related-analyses a.related-anls-link').each(function() {
              $(this).click(function() {
                com.bouncingdata.Nav.fireAjaxLoad($(this).prop('href'), false);
                return false;
              });
            });
          });
      	</script>
      </c:if>
    </div-->  
    
    
    <div class="dataset-summary summary">
      <div class="author-summary">       
        <a class="author-avatar" href="javascript:void(0);"><img src="<c:url value="/resources/images/no-avatar.png" />" /></a>       
        <p class="author-name"><a href="javascript:void(0);"><strong>${dataset.user.username }</strong></a></p>
        <p class="published-date">Published on ${dataset.shortCreateAt }</p>
        <div class="clear"></div>
      </div>
      <p><strong>Reference: </strong><a href="#">http://www.economist.com/football</a></p>
      <p><strong>Dataset Collection: </strong><a href="#">NFL 2000-2010</a></p>
      <p><strong>Source: </strong><a href="#">http://www.footballdata.com/gamedata</a></p>
      <p><strong>License: </strong><a href="#">X</a></p>
      <p><strong>Last updated: </strong>${dataset.shortLastUpdate }</p>
    </div>
    <div class="tag-set">
      <div class="tag-list">
      <c:if test="${not empty dataset.tags }">
        <c:forEach items="${dataset.tags }" var="tag">
          <div class="tag-element-outer">
            <a class="tag-element" href="<c:url value="/tag/${dataset.tag }" />">${dataset.tag }</a>
            <c:if test="${isOwner }">
              <span class="tag-remove" title="Remove tag from this dataset">x</span>
            </c:if>
          </div>
        </c:forEach>  
      </c:if>
      
      </div>&nbsp;
      <c:if test="${isOwner }">
        <a class="add-tag-link" href="javascript:void(0);">
          Add tag
        </a>
        <div class="add-tag-popup" style="display: none;">
          <input type="text" id="add-tag-input" />
          <input type="button" value="Add" id="add-tag-button" />
        </div>
      </c:if>
      
    </div>
    <div class="dataset-related-info related-info">
      <p><strong>Related:</strong></p>
      <div class="related-tabs ui-tabs" id="related-tabs">
        <ul>
          <li><a href="#related-dataset">Dataset</a></li>
          <li><a href="#related-author">Author</a></li>
          <li><a href="#related-voters">Voters</a></li>
        </ul>
        <div id="related-dataset" class="ui-tabs-hide"></div>
        <div id="related-author" class="ui-tabs-hide"></div>
        <div id="related-voters" class="ui-tabs-hide"></div>
      </div>
      
    </div>
  </div>
  <div class="center-content">
    <div class="center-content-wrapper">
      <div class="dataset-header header">
        <div class="dataset-title main-title"><h2>${dataset.name}</h2></div>
        <div class="share-panel" style="float: right;">
          <!-- AddThis Button BEGIN -->
          <div class="addthis_toolbox addthis_default_style ">
          <a class="addthis_button_preferred_1"></a>
          <a class="addthis_button_preferred_2"></a>
          <a class="addthis_button_preferred_3"></a>
          <a class="addthis_button_preferred_4"></a>
          <a class="addthis_button_compact"></a>
          <a class="addthis_counter addthis_bubble_style"></a>
          </div>
          <script type="text/javascript">
            var addthis_config = addthis_config||{};
            addthis_config.data_track_addressbar = false;
            //var addthis_config = {"data_track_addressbar":true};
          </script>
          <script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-512cd44d6cd449d2"></script>
          <!-- AddThis Button END -->
        </div>
        <div class="action-links dataset-action-links" style="margin-top: 4px;">
          <h3 class="dataset-score score">0</h3>&nbsp;
          <a href="javascript:void(0);" class="action vote-up dataset-vote-up">Vote up</a>&nbsp;&nbsp;
          <a href="javascript:void(0);" class="action vote-down dataset-vote-down">Vote down</a>&nbsp;&nbsp;
          <a href="javascript:void(0)" class="action dataset-action dataset-embed-button" id="dataset-embed-button">Embed</a>&nbsp;&nbsp;
          <a href="<c:url value="/dataset/dl/csv/${dataset.guid}"/>" class="action dataset-action">Download CSV</a>&nbsp;&nbsp;
          <a href="<c:url value="/dataset/dl/json/${dataset.guid}"/>" class="action dataset-action">Download JSON</a>
        </div>
      </div>
      <div class="header-rule"></div>
      <div class="dataset-content data-tab-container ui-tabs" id="dataset-content">
        <form id="search-query" method="post" action="<c:url value="/dataset/squery"/>">
	        <div id="divQuery">
	          <input type="text" id="q" name="q" value="Search query ..." onblur="if(value=='') value = 'Search query ...'" onfocus="if(value=='Search query ...') value = ''" title="Syntax: [* || `colname1`,`colname2`,...], condition clause (Column name must be quote in ``)"/>
	          <input type="hidden" id="oq" name="oq" value="${dataset.guid}"/>
			</div>
        </form>	
        
        <ul>
          <li><a href="#data">View</a></li>
          <li><a href="#schema">Schema</a></li>
          <li><a href="#ref-doc">Reference Doc</a></li>
        </ul>
        <div class="clear"></div>
        <div id="data" class="ui-tabs-hide">
          <table class="data-table" id="data-table">
          </table>
          <c:choose>
            <c:when test="${not empty data }">
              <script>
                var data = ${data};
                var $table = $('#data-table');
                com.bouncingdata.Utils.renderDatatable(data, $table, 
                     {
                	   "sScrollY": "400px", "bPaginate": false, "bFilter": false 
                	 //"bFilter": false ,"sPaginationType": "full_numbers" 
                     });
                     
              </script>
            </c:when>
            <c:otherwise>
              <script>
              $(function() {
                console.debug("Load datatable by Ajax...");
                var guid = '${guid}';
                var columns = ${columns};
                var $table = $('#data-table');
                com.bouncingdata.Workbench.loadDatatableByAjax(guid, columns, $table);               
              });
              </script>  
            </c:otherwise>
          </c:choose>
        </div>
        <div id="schema" class="ui-tabs-hide">
          <!-- pre style="white-space: normal; word-wrap: break-word;">${dataset.schema }</pre-->
          <pre class="brush: sql" style="white-space: pre-wrap; word-wrap: break-word;">${dataset.schema }</pre>
        </div>
        <div id="ref-doc" class="ui-tabs-hide">
          <c:choose>
            <c:when test="${not empty dataset.refDocuments }">
              <c:set var="baseURL" value="${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, pageContext.request.contextPath)}" />
              <c:forEach items="${dataset.refDocuments }" var="ref">
                <c:if test="${ref.type == 'url' }">
                  <p>
                    <a>${ref.url }</a>
                  </p>
                </c:if>
                <c:if test="${ref.type == 'pdf' }">
                  <div>
                    <h4>${ref.name }</h4>
                    <p>
                      <iframe src="http://docs.google.com/viewer?url=${baseURL }/public/ref/${dataset.guid }?ref=${ref.guid }&embedded=true" style="width: 100%; height: 460px;" frameborder="0"></iframe>
                    </p>
                  </div>
                </c:if>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <span>No reference document.</span>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      <div class="clear"></div>
      <div class="description">
        <h3 style="margin: 0 0 10px; cursor: pointer">Description</h3>
        <c:choose>
          <c:when test="${not empty dataset.description }">
            <span>${dataset.description }</span>
          </c:when>
          <c:otherwise>
            <span>No description</span>
          </c:otherwise>
        </c:choose>
      </div>
      <!-- <div class="comments-container">
        <h3 class="comments-title">
          <a href="javascript:void(0);" onclick="$('#comment-form').toggle('slow');">Comment</a>
        </h3>
        <div class="comment-form" id="comment-form">
          <form>
            <fieldset>
              <p>
                <textarea rows="5" id="message"></textarea>
              </p>
              <p>
                <input type="button" class="comment-submit" id="comment-submit" value="Post comment">
              </p>
            </fieldset>
          </form>
        </div>
        <div class="clear"></div>
        <label id="comments"></label>
        <div class="comments">
          <h3 class="comments-count">Comments</h3>
          <ul id="comment-list" class="comment-list">
          </ul>
        </div>
      </div> -->
    </div>
  </div>
</div>
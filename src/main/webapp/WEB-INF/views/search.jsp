<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
	$(function() {
	  $('.result-analysis ul.analysis-list li').each(function() {
	    var $link = $('a.anls-item', $(this));
	    $link.click(function() {
	      com.bouncingdata.Nav.fireAjaxLoad($link.prop('href'), false);
	      return false;
	    });
	  });
	  
	  $('.result-dataset ul.dataset-list li').each(function() {
	    var $link = $('a.dataset-item', $(this));
	    $link.click(function() {
	      com.bouncingdata.Nav.fireAjaxLoad($link.prop('href'), false);
	      return false;
	    });
	  });
	  
	  com.bouncingdata.Nav.setSelected('search', '${query}');
	});
</script>
<div id="main-content" class="main-content search-page">
  <div class="right-content"></div>
  <div class="center-content">
    <div class="center-content-wrapper search-result-wrapper">
      <div>Search result for <strong>${query}</strong>:</div>
      <div class="search-result-nav">
        <a class="result-all" href="javascript:void(0);">All</a>&nbsp;&nbsp;|&nbsp;&nbsp;
        <a class="result-anls" href="javascript:void(0);">Analysis</a>&nbsp;&nbsp;|&nbsp;&nbsp;
        <a class="result-scraper" href="javascript:void(0);">Scraper</a>&nbsp;&nbsp;|&nbsp;&nbsp;
        <a class="result-dataset" href="javascript:void(0);">Dataset</a>
      </div>

      <div class="search-result">
        <h3>
          <span class="result-title">Analysis</span> &nbsp;&nbsp;
        </h3>
        <ul class="analysis-list search-result-list">
          <c:choose>
            <c:when test="${empty searchResult.analyses }">No analysis matched.</c:when>
            <c:otherwise>
              <c:forEach items="${searchResult.analyses }" var="anls">
                <li>
                  <!-- a class="anls-item" href="<c:url value="/anls/${anls.guid}" />" title="View analysis">${anls.name }</a-->
                  <div class="search-result-item">
                    <div class="thumbnail">
                      <a href="<c:url value="/anls/${anls.guid}" />" class="anls-item">
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
                      <a class="anls-item" href="<c:url value="/anls/${anls.guid}" />" title="View analysis"><strong>${anls.name}</strong></a>
                      <br style="line-height: 18px;" />
                      by <a class="user-link" href="">${anls.user.username }</a>
                    </p>
                    <p class="description">
                      <span>${anls.description }</span>
                    </p>
                    <div class="clear"></div>
                  </div>
                </li>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </ul>
      </div>

    </div>
  </div>
</div>
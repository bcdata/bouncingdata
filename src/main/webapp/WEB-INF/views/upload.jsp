<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<script>
	com.bouncingdata.Main.loadCss(ctx
			+ "/resources/css/bouncingdata/analysis.css", "analysis");
	$(function() {
		$('#dataset-content').tabs();
		//SyntaxHighlighter.highlight();
		com.bouncingdata.Nav.setSelected('data', '${dataset.guid}');
	});
</script>
<script language="javascript" type="text/javascript">
		function toggleDiv(){ 
			 var dvPage1 = document.getElementById("dvPage1");
			 var dvPage2 = document.getElementById("dvPage2");
			 var btnNext = document.getElementById("btn-next");
			 var btnBack = document.getElementById("btn-back");
			 
		
		        if (dvPage2.style.display == "block") 
		        {
			        dvPage1.style.display = "block";
			       	dvPage2.style.display = "none";
			       	btnBack.style.display = "none";
			       	btnNext.style.display = "block";
		        } 
		        else 
		        { 
		          dvPage1.style.display = "none";
		          dvPage2.style.display = "block";
			      btnBack.style.display = "block";
			      btnNext.style.display = "none";
		        } 
		      } 
</script>


<div id="main-content" class="upload-container">
	<div class="right-content" style="color: #555555;"></div>
	<div class="center-content">
		<div class="center-content-wrapper">
			<div class="stream-container center-content-main">
				<div style="float: left; width: 100%; height: 70px; margin-top: 20px;">
					<table style="width: 100%;">
						<tr>
							<td>
								<div style="height: 30px;">
									<input type="image"
										src="<c:url value="/resources/images/close-round.png"/>"
										width="32" height="30"/>
								</div>
								<div style="font-size: 14px; color: #5A5A5A;">
									<b>Close</b>
								</div>
							</td>
							<td align="center">
								<a id="fileLk" href="#">File</a><a id="descriptionLk" href="#">Description & Schema</a>
							</td>
							<td align="right">
								<div id="btn-next" style="display:block;">
									<input type="image" src="<c:url value='/resources/images/next.png'/>" width="32" height="30" OnClick="toggleDiv()"/>
								</div>
								<div id="btn-back" style="display:none;">
									<div style="height: 30px;">
										<input type="image" src="<c:url value="/resources/images/back.png" />" width="32" height="30" OnClick="toggleDiv()"/>
										
										<input type="image" src="<c:url value="/resources/images/publish.png" />" width="32" height="30" OnClick="toggleDiv()"/>
									</div>
									
									<div style="font-size: 14px; color: #5A5A5A;">
										<input type="checkbox"> Publish
									</div>
								</div>
							</td>
							
						</tr>
					</table>
					
					<hr>
				</div>

				<div class="container">
					<div class="row ">
						<div name="dvPage1" id="dvPage1" style="display: block;">
							<!-- FILE LOCATION -->
							<div class="notice_message">Required</div>
							<div id="content" class="ninecol last">
								<div class="panel-wrapper">
									<div class="panel">
										<div class="title">
											<h4>1. File Location</h4>
											<div class="collapse">collapse</div>
										</div>
										<div class="content">
											<!-- ## Panel Content  -->
											<form method="post" action="">
												<div class="inline">
													<label>We support the following file types: pdf,
														txt, csv, xls, xlsx, rdata (data frame).</label>
												</div>
												<div class="inline">
													<table cellspacing="0" cellpadding="0">
														<thead>
															<tr>
																<td><strong>Web</strong></td>
																<td><strong><input type="text"
																		value="Web address"></strong></td>
															</tr>
															<tr>
																<td></td>
																<td align="center"><strong>Or</strong></td>
															</tr>
															<tr>
																<td><strong>Local</strong></td>
																<td align="center"><input type="file"
																	name="fl_browse"></td>
															</tr>
														</thead>
													</table>
												</div>


											</form>

											<!-- ## / Panel Content  -->
										</div>
									</div>
									<div class="shadow"></div>
								</div>
							</div>
							<!-- END FILE LOCATION -->


							<!-- LOADING OPTIONS -->
							<div class="clear"></div>

							<div class="notice_message">Optional</div>
							<div id="content" class="ninecol last">
								<div class="panel-wrapper">
									<div class="panel">
										<div class="title">
											<h4>2. Loading Options</h4>
											<div class="collapse">collapse</div>
										</div>
										<div class="content">
											<table cellspacing="0" cellpadding="0">
												<thead>
													<tr>
														<td><strong>Header</strong></td>
														<td><strong><input type="checkbox">First
																row is header<br></strong></td>
													</tr>
													<tr>
														<td><strong>Demiliter</strong></td>
														<td align="left"><strong> <select>
																	<option value="tab">Tab</option>
																	<option value="comma">Comma</option>
																	<option value="period">Period</option>
															</select>
														</strong></td>
													</tr>
												</thead>
											</table>
										</div>
									</div>
									<div class="shadow"></div>
								</div>
							</div>
							<!-- END LOADING OPTIONS -->
						</div>
						<div name="dvPage2" id="dvPage2" style="display: none;">
							
							<div class="notice_message">Recommended</div>
							<div id="content" class="ninecol last">
								<div class="panel-wrapper">
									<div class="panel">
										<div class="title">
											<h4>1. Schema</h4>
											<div class="collapse">collapse</div>
										</div>
										<div class="content">
											<form method="post" action="">
												<div class="inline">
													<label>Set Column Names, Data Types, Column
														Description, and Add Reference Doc.</label>
												</div>

												<!-- Title -->
												<div class="pnl-dv-title">
													<a href="#" class="link-lf">View</a><a href="#"
														class="link-ct active">Schema</a><a href="#"
														class="link-rg">Add Reference Doc</a>
												</div>
												<!-- End Title -->

												<div class="inline">
													<table class="tblcontent">
														<tr>
															<th>Column Name</th>
															<th>Data Type</th>
															<th>Column Description</th>
														</tr>
														<tr>
															<td>Smith</td>
															<td>John</td>
															<td>jsmith@gmail.com</td>
														</tr>
														<tr>
															<td>Bach</td>
															<td>Frank</td>
															<td>$50.00</td>
														</tr>
														<tr>
															<td>Doe</td>
															<td>Jason</td>
															<td>$100.00</td>
														</tr>
														<tr>
															<td>Conway</td>
															<td>Tim</td>
															<td>$50.00</td>
														</tr>
													</table>
												</div>

												<!-- Title -->
												<div class="pnl-dv-title">
													<a href="#" class="link-lf">View</a><a href="#"
														class="link-ct">Schema</a><a href="#"
														class="link-rg active">Add Reference Doc</a>
												</div>
												<!-- End Title -->
												<div class="pnl-no-title">
													<div class="inline"></div>
													<div class="inline">
														<label>Comment : This is what it look like when
															click on Add Reference Doc</label>
													</div>
													<div class="inline">
														<label>Comment : Under View, we should display
															maybe top 100 rows only</label>
													</div>
													<div class="inline">
														<table cellspacing="0" cellpadding="0">
															<thead>
																<tr>
																	<td><strong>Web</strong></td>
																	<td><strong><input type="text"
																			value="Web address"></strong></td>
																</tr>
																<tr>
																	<td></td>
																	<td align="center"><strong>Or</strong></td>
																</tr>
																<tr>
																	<td><strong>Local</strong></td>
																	<td align="center"><input type="file"
																		name="fl_browse"></td>
																</tr>
															</thead>
														</table>
													</div>
												</div>
											</form>
										</div>
									</div>
									<div class="shadow"></div>
								</div>
							</div>
							<!-- END LOADING OPTIONS -->

							<!-- LOADING OPTIONS -->
							<div class="clear"></div>

							<div class="notice_message">Required</div>
							<div id="content" class="ninecol last">
								<div class="panel-wrapper">
									<div class="panel">
										<div class="title">
											<h4>2. Description</h4>
											<div class="collapse">collapse</div>
										</div>
										<div class="content">
											<!-- ## Panel Content  -->
											<form method="post" action="">
												<div style="width: 100%;">
													<input type="text" value="Dataset Name"
														onblur="if(value=='') value = 'Dataset Name'"
														onfocus="if(value=='Dataset Name') value = ''">
												</div>
												<div>
													<textarea class="ckeditor" cols="80" id="editor1"
														name="editor1" rows="10"></textarea>
												</div>
											</form>
											<!-- ## / Panel Content  -->
										</div>
									</div>
									<div class="shadow"></div>
								</div>
							</div>
							<!-- END LOADING OPTIONS -->
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>
</div>
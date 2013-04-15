<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>

<script>
	//  com.bouncingdata.ActivityStream.init();

	$(function() {
		$("#accordion").accordion({
			header : "h3",
			collapsible : true,
			heightStyle: "content"
		});
	});
</script>


<div id="main-content" class="homepage-container">
	<div class="right-content"></div>
	<div class="center-content">
		<div class="center-content-wrapper">
			<div id="accordion" style="margin-top: 10px;margin-left: 15px;width: 95%;">
				<div>
					<h3>
						<a href="#">Section 1</a>
					</h3>
					<div>Mauris mauris ante, blandit et, ultrices a, suscipit
						eget, quam. Integer ut neque. Vivamus nisi metus, molestie vel,
						gravida in, condimentum sit amet, nunc.</div>
				</div>
				<div>
					<h3>
						<a href="#">Section 2</a>
					</h3>
					<div>Sed non urna. Donec et ante. Phasellus eu ligula.
						Vestibulum sit amet purus. Vivamus hendrerit, dolor at aliquet
						laoreet, mauris turpis porttitor velit, faucibus interdum tellus
						libero ac justo. Vivamus non quam. In suscipit faucibus urna.</div>
				</div>
				<div>
					<h3>
						<a href="#">Section 3</a>
					</h3>
					<div>Nam enim risus, molestie et, porta ac, aliquam ac,
						risus. Quisque lobortis. Phasellus pellentesque purus in massa.
						Aenean in pede. Phasellus ac libero ac tellus pellentesque semper.
						Sed ac felis. Sed commodo, magna quis lacinia ornare, quam ante
						aliquam nisi, eu iaculis leo purus venenatis dui.</div>
				</div>
				<div>
					<h3>
						<a href="#">Section 4</a>
					</h3>
					<div>
						<p>Nam enim risus, molestie et, porta ac, aliquam ac, risus.
							Quisque lobortis. Phasellus pellentesque purus in massa. Aenean
							in pede. Phasellus ac libero ac tellus pellentesque semper. Sed
							ac felis. Sed commodo, magna quis lacinia ornare, quam ante
							aliquam nisi, eu iaculis leo purus venenatis dui.
							
							Nam a nibh. Donec suscipit
						eros. Nam mi. Proin viverra leo ut odio. Curabitur malesuada.
						Vestibulum a velit eu ante scelerisque vulputate.</p>
						<ul>
							<li>List item one</li>
							<li>List item two</li>
							<li>List item three</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
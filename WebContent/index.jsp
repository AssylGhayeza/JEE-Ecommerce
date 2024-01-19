<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Carrefour</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #2ea5c7;">

	<%
	/* Validating user access */
	String accountName = (String) session.getAttribute("username");
	String accountPassword = (String) session.getAttribute("password");
	String accountType = (String) session.getAttribute("usertype");

	boolean accessGranted = accountType != null && accountName != null && accountPassword != null && accountType.equals("customer");

	ProductServiceImpl productService = new ProductServiceImpl();
	List<ProductBean> productList = new ArrayList<>();

	String searchQuery = request.getParameter("search");
	String productType = request.getParameter("type");
	String displayMessage = "";
	if (searchQuery != null) {
		productList = productService.searchAllProducts(searchQuery);
		displayMessage = "Showing Results for '" + searchQuery + "'";
	} else if (productType != null) {
		productList = productService.getAllProductsByType(productType);
		displayMessage = "Showing Results for '" + productType + "'";
	} else {
		productList = productService.getAllProducts();
	}
	if (productList.isEmpty()) {
		displayMessage = "No items found for the search '" + (searchQuery != null ? searchQuery : productType) + "'";
		productList = productService.getAllProducts();
	}
	%>

	<jsp:include page="header.jsp" />

	<div class="text-center"
		style="color: black; font-size: 14px; font-weight: bold;"><%=displayMessage%></div>
	<div class="text-center" id="message"
		style="color: black; font-size: 14px; font-weight: bold;"></div>
	<!-- Start of Product Items List -->
	<div class="container">
		<div class="row text-center">

			<%
			for (ProductBean item : productList) {
				int quantityInCart = new CartServiceImpl().getCartItemCount(accountName, item.getProdId());
			%>
			<div class="col-sm-3" style='height: 350px;'>
				<div class="thumbnail">
					<img src="./ShowImage?pid=<%=item.getProdId()%>" alt="Product"
						style="height: 160px; max-width: 180px">
					<p class="productname"><%=item.getProdName()%>
					</p>
					<%
					String productDescription = item.getProdInfo();
					productDescription = productDescription.substring(0, Math.min(productDescription.length(), 100));
					%>
					<p class="productinfo"><%=productDescription%>..
					</p>
					<p class="price">
						<%=item.getProdPrice()%>
						TND
					</p>
					<form method="post">
						<%
						if (quantityInCart == 0) {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=accountName%>&pid=<%=item.getProdId()%>&pqty=1"
							class="btn btn-success">Add to Cart</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="./AddtoCart?uid=<%=accountName%>&pid=<%=item.getProdId()%>&pqty=1"
							class="btn btn-primary">Buy Now</button>
						<%
						} else {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=accountName%>&pid=<%=item.getProdId()%>&pqty=0"
							class="btn btn-danger">Remove From Cart</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit" formaction="cartDetails.jsp"
							class="btn btn-success">Checkout</button>
						<%
						}
						%>
					</form>
					<br />
					<br />
				</div>
			</div>

			<%
			}
			%>

		</div>
	</div>
	<!-- End of Product Items List -->


	<%@ include file="footer.html"%>

</body>
</html>

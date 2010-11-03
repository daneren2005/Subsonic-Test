<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>

<html><head>
    <%@ include file="head.jsp" %>
    <script type="text/javascript" src="<c:url value="/dwr/interface/coverArtService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/prototype.js"/>"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>

    <script type="text/javascript" language="javascript">

        dwr.engine.setErrorHandler(null);
        google.load('search', '1');

        var imageSearch;

        function getImages(service) {
            $("wait").style.display = "inline";
//            $("images").style.display = "none";
            $("success").style.display = "none";
            $("error").style.display = "none";
            $("errorDetails").style.display = "none";
            $("noImagesFound").style.display = "none";
        }

        function getImagesCallback(imageUrls) {
            var html = "";
            for (var i = 0; i < imageUrls.length; i++) {
                html += "<a href=\"javascript:setImage('" + imageUrls[i].imageDownloadUrl + "')\"><img src='" + imageUrls[i].imagePreviewUrl + "' style='padding:5pt' alt=''/></a>";
            }
            dwr.util.setValue("images", html, { escapeHtml:false });

            $("wait").style.display = "none";
            if (imageUrls.length > 0) {
//                $("images").style.display = "inline";
            } else {
                $("noImagesFound").style.display = "inline";
            }
        }

        function setImage(imageUrl) {
            $("wait").style.display = "inline";
//            $("images").style.display = "none";
            $("success").style.display = "none";
            $("error").style.display = "none";
            $("errorDetails").style.display = "none";
            $("noImagesFound").style.display = "none";
            var path = dwr.util.getValue("path");
            coverArtService.setCoverArtImage(path, imageUrl, setImageCallback);
        }

        function setImageCallback(errorDetails) {
            $("wait").style.display = "none";
            if (errorDetails != null) {
                dwr.util.setValue("errorDetails", "<br/>" + errorDetails, { escapeHtml:false });
                $("error").style.display = "inline";
                $("errorDetails").style.display = "inline";
            } else {
                $("success").style.display = "inline";
            }
        }

        function searchComplete() {

            // Check that we got results
            if (imageSearch.results && imageSearch.results.length > 0) {

                // Grab our content div, clear it.
                var images = document.getElementById("images");
                images.innerHTML = '';

                // Loop through our results, printing them to the page.
                var results = imageSearch.results;
                for (var i = 0; i < results.length; i++) {
                    // For each result write it's title and image to the screen
                    var result = results[i];


                    var node = $("template").cloneNode(true);

                    var thumbnail = node.getElementsByClassName("thumbnail")[0];
                    thumbnail.src = result.tbUrl;
                    thumbnail.onclick = "setImage('" + result.url + "');";

                    var title = node.getElementsByClassName("title")[0];
                    title.innerHTML = result.contentNoFormatting;

                    var dimension = node.getElementsByClassName("dimension")[0];
                    dimension.innerHTML = result.width + " � " + result.height;

                    var url = node.getElementsByClassName("url")[0];
                    url.innerHTML = result.visibleUrl;


                    node.show();

                    // attach the node into my dom
                    images.appendChild(node);




                    //              var imgContainer = document.createElement('div');
//              var title = document.createElement('div');
//
//              // We use titleNoFormatting so that no HTML tags are left in the
//              // title
//              title.innerHTML = result.titleNoFormatting;
//                    var image = document.createElement('img');
//                    image.src = result.url;
//                    contentDiv.appendChild(image);
                }

                // Now add links to additional pages of search results.
                addPaginationLinks(imageSearch);
            }
        }

        function addPaginationLinks() {

            // To paginate search results, use the cursor function.
            var cursor = imageSearch.cursor;
            var curPage = cursor.currentPageIndex; // check what page the app is on
            var pagesDiv = document.createElement('div');
            for (var i = 0; i < cursor.pages.length; i++) {
                var page = cursor.pages[i];
                var label;
                if (curPage == i) {
                    // If we are on the current page, then don't make a link.
                    label = document.createElement("b");
                } else {

                    // Create links to other pages using gotoPage() on the searcher.
                    label = document.createElement("a");
                    label.href = 'javascript:imageSearch.gotoPage('+i+');';
                }
                label.innerHTML = page.label;
                label.style.marginRight = "1em";
                pagesDiv.appendChild(label);
            }

            var pages = $("pages");
            pages.innerHTML = "";
            pages.appendChild(pagesDiv);
        }


        function search() {
            var query = dwr.util.getValue("query");
            imageSearch.execute(query);
        }

        function onLoad() {

            // Create an Image Search instance.
            imageSearch = new google.search.ImageSearch();

            // Set searchComplete as the callback function when a search is
            // complete.  The imageSearch object will have results in it.
            imageSearch.setSearchCompleteCallback(this, searchComplete, null);
            imageSearch.setNoHtmlGeneration();
            imageSearch.setResultSetSize(8);


            // Include the required Google branding
            google.search.Search.getBranding('branding');

            $("template").hide();

            search();
        }
        google.setOnLoadCallback(onLoad);


    </script>
</head>
<body class="mainframe bgcolor1">
<h1><fmt:message key="changecoverart.title"/></h1>
<form action="javascript:search()">
    <table class="indent"><tr>
        <td><input id="query" name="query" size="70" type="text" value="${model.artist} ${model.album}" onclick="select()"/></td>
        <td style="padding-left:0.5em"><input type="submit" value="<fmt:message key="changecoverart.search"/>"/></td>
    </tr></table>
</form>

<form action="javascript:setImage(dwr.util.getValue('url'))">
    <table><tr>
        <input id="path" type="hidden" name="path" value="${model.path}"/>
        <td><label for="url"><fmt:message key="changecoverart.address"/></label></td>
        <td style="padding-left:0.5em"><input type="text" name="url" size="50" id="url" value="http://" onclick="select()"/></td>
        <td style="padding-left:0.5em"><input type="submit" value="<fmt:message key="common.ok"/>"></td>
    </tr></table>
</form>
<sub:url value="main.view" var="backUrl"><sub:param name="path" value="${model.path}"/></sub:url>
<div style="padding-top:0.5em;padding-bottom:0.5em">
    <div class="back"><a href="${backUrl}"><fmt:message key="common.back"/></a></div>
</div>

<h2 id="wait" style="display:none"><fmt:message key="changecoverart.wait"/></h2>
<h2 id="noImagesFound" style="display:none"><fmt:message key="changecoverart.noimagesfound"/></h2>
<h2 id="success" style="display:none"><fmt:message key="changecoverart.success"/></h2>
<h2 id="error" style="display:none"><fmt:message key="changecoverart.error"/></h2>
<div id="errorDetails" class="warning" style="display:none">
</div>


<div id="images" style="width:100%">
</div>

<div style="clear:both;">
</div>

<div id="pages" style="float:left;padding-left:0.5em; padding-bottom:2em; padding-top:2em">
</div>

<div id="branding" style="float:right;padding-right:1em; padding-bottom:2em; padding-top:2em">
</div>

<div id="template" style="float:left; height:190px; width:220px;padding:0.5em;position:relative">
    <div style="position:absolute;bottom:0">
        <img class="thumbnail" src="">
        <div class="title"></div>
        <div class="dimension detail"></div>
        <div class="url detail"></div>
    </div>
</div>

</body></html>
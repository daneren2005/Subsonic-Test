<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>

<html>
<head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
    <link rel="stylesheet" type="text/css" href="<c:url value="/style/videoPlayer.css"/>">
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/starService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/jwplayer-5.10.min.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/cast_sender-v1.js"/>"></script>
    <%@ include file="videoPlayerCast.jsp" %>

    <script type="text/javascript" language="javascript">
        function toggleStar(mediaFileId, element) {
            starService.star(mediaFileId, !$(element).hasClass("fa-star"));
            $(element).toggleClass("fa-star fa-star-o starred");
        }
    </script>
</head>

<body class="mainframe bgcolor1" style="padding-bottom:0.5em">

<c:set var="licenseInfo" value="${model.licenseInfo}"/>
<%@ include file="licenseNotice.jsp" %>

<c:if test="${licenseInfo.licenseOrTrialValid}">
    <div>
        <div id="overlay">
            <div id="overlay_text">Playing on Chromecast</div>
        </div>
        <div id="jwplayer"><a href="http://www.adobe.com/go/getflashplayer" target="_blank">Get Flash</a></div>
        <div id="media_control">
            <div id="progress_slider"></div>
            <div id="play"></div>
            <div id="pause"></div>
            <div id="progress">0:00</div>
            <div id="duration">0:00</div>
            <div id="audio_on"></div>
            <div id="audio_off"></div>
            <div id="volume_slider"></div>
            <select name="bitrate_menu" id="bitrate_menu">
                <c:forEach items="${model.bitRates}" var="bitRate">
                    <c:choose>
                        <c:when test="${bitRate eq model.defaultBitRate}">
                            <option selected="selected" value="${bitRate}">${bitRate} Kbps</option>
                        </c:when>
                        <c:otherwise>
                            <option value="${bitRate}">${bitRate} Kbps</option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
            <div id="share"></div>
            <div id="download"></div>
            <div id="casticonactive"></div>
            <div id="casticonidle"></div>
        </div>
    </div>
    <div id="debug"></div>

    <script type="text/javascript">
        var CastPlayer = new CastPlayer();
    </script>
</c:if>

<h1 style="padding-top:1em;padding-bottom:0.5em;">
    <i class="fa ${not empty model.video.starredDate ? 'fa-star starred' : 'fa-star-o'} clickable"
       onclick="toggleStar(${model.video.id}, this)" style="padding-right:0.25em"></i>&nbsp;${fn:escapeXml(model.video.title)}
</h1>

<sub:url value="main.view" var="backUrl"><sub:param name="id" value="${model.video.id}"/></sub:url>

<i class="fa fa-chevron-left icon"></i>&nbsp;<a href="${backUrl}"><fmt:message key="common.back"/></a>

</body>
</html>

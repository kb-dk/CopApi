<%@taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                    aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#"></a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                <li <c:if test = "${param.active=='dsfl'}"> class="active" </c:if>><a href="dsfl">DSFL</a></li>
                <li <c:if test = "${param.active=='cop'}"> class="active" </c:if>><a href="cop">COP</a></li>
                <li <c:if test = "${param.active=='text'}"> class="active" </c:if>><a href="text">TEXT</a></li>
                <li <c:if test = "${param.active=='documentation'}"> class="active" </c:if>><a href="documentation">Documentation</a></li>
            </ul>
        </div>
    </div>
</nav>

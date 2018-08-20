<%@taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<header class="org-c3af7b08-07d8-4a3e-8b12-5b6de87acf0c">
    <div class="inner-content grid-container">
        <div class="grid-x">
            <div class="small-6 large-3 cell" >
                <jsp:include page="../../atoms/logo/index.jsp" />
            </div>
            <div class="small-6 hide-for-large cell" >
                <jsp:include page="../../atoms/hamburger-menu/index.jsp" />
            </div>
            <div class="show-for-large medium-9 cell navs">
                <nav class="top-nav">
                    <ul>
                        <li><a href="http://www.kb.dk/danmarksetfraluften">Danmark set fra luften</a></li>
                        <li><a href="http://www.kb.dk/editions/any/2009/jul/editions/da">Digitale samlinger</a></li>
                        <li><a href="http://text-test.kb.dk/">Tekstportal</a></li>
                    </ul>
                </nav>
                <nav class="main-nav">
                    <ul>
                        <li><a href="dsfl">DSfL</a></li>
                        <li><a href="cop">COP</a></li>
                        <li><a href="text">TEXT</a></li>
                        <li><a href="documentation">DOCUMENTATION</a></li>
                    </ul>
                </nav>
            </div>
        </div>
        <%--<div class="top-menu">--%>
            <%--@@include('./molecules/search-form/index.html', {"placeholder": "Søg på KB.dk", "classes": "top-menu collapsed"})--%>
        <%--</div>--%>
    </div>
    <div class="hide-for-large">
        <jsp:include page="../../organisms/mobile-menu/index.jsp" />
    </div>
</header>

<footer>
  <div class="inner-content grid-container">
    <div class="grid-x grid-padding-x grid-padding-y">
      <div class="small-6 medium-3 cell">
        <%--@@include('./molecules/link-list/index.html')--%>
        <jsp:include page="../../molecules/link-list/index.jsp" />
      </div>
      <div class="small-6 medium-3 cell">
        <%--@@include('./molecules/other-links/index.html')--%>
        <jsp:include page="../../molecules/link-list/index.jsp" />
      </div>
      <div class="small-6 medium-3 cell">
        <%--@@include('./molecules/info-links/index.html')--%>
        <jsp:include page="../../molecules/link-list/index.jsp" />
      </div>
      <div class="small-6 medium-3 cell">
        <%--@@include('./molecules/contact-info/index.html')--%>
        <jsp:include page="../../molecules/link-list/index.jsp" />
      </div>
      <div class="small-12 show-for-small-only cell">
        <div class="box flex-container align-center">
          <%--<a href="">@@include('./atoms/icon/index.html', {"icon-type" : "icon-facebook", "icon-size" : "icon-medium"})</a>--%>
          <%--<a href="">@@include('./atoms/icon/index.html', {"icon-type" : "icon-twitter", "icon-size" : "icon-medium"})</a>--%>
        </div>
      </div>
    </div>
  </div>
</footer>

<div class="mol-84808011-3678-4f25-9e6b-db25897b6de1">
    <form class="form-wrapper search-area search-area" onsubmit="event.preventDefault();">
        <%--@@include('./atoms/input/index.html', {"type": "text", "placeholder": "@@placeholder"})--%>
        <%--@@if (close) {--%>
            <%--<button alt="clear">@@include('./atoms/icon/index.html',{"icon-type":"icon-clear","icon-size":"icon-small"})</button>--%>
        <%--}--%>
        <%--@@if (!close) {--%>
            <button id="${ param.id }" alt="search">
                 <span class="btn input-group-addon" data-clipboard-target="#${ param.id }">
                <jsp:include page="../../atoms/icon/index.jsp">
                    <jsp:param name="icon_type" value="icon-copy"/>
                    <jsp:param name="icon_size" value="icon-medium"/>
            </jsp:include>
                 </span>
            </button>
        <%--}--%>
    </form>
</div>

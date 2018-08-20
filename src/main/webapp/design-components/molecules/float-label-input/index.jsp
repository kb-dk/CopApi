<div class="mol-ef63e9db-1c74-43c1-82e7-4c8b8c5bfa00 float-label">
    <div class="wrapper">
        <label>${ param.placeholder }</label>
        <input id="${ param.id }" type="text" placeholder="${ param.placeholder }"/>
        <button alt="submit" class="button invisible"></button>
        <span class="btn" data-clipboard-target="#${ param.id }">
             <jsp:include page="../../atoms/icon/index.jsp">
                 <jsp:param name="icon_type" value="icon-copy"/>
                 <jsp:param name="icon_size" value="icon-medium"/>
              </jsp:include>
        </span>
    </div>
    <span class="error-message">Error message</span>
    <span class="instruction">Instruction message</span>
</div>
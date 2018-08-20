<html>
    <head>
        <title>KB API Demo</title>
        <meta charset="utf-8"/>

        <!-- JQUERY -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

        <!-- PAGINATION -->
        <script type="text/javascript" src="js/jquery.simplePagination.js"></script>
        <link type="text/css" rel="stylesheet" href="css/simplePagination.css"/>

        <!-- CLIPBOARD -->
        <script src="js/clipboard.min.js"></script>
        <%--<link type="text/css" rel="stylesheet" href="css/style.css"/>--%>
        <link type="text/css" rel="stylesheet" href="css/kbdk-styles.css"/>
        <link type="text/css" rel="stylesheet" href="css/custom.css"/>

    </head>

    <body class="theme-yellow">

        <jsp:include page="design-components/organisms/header/index.jsp">
            <jsp:param name="active" value="dsfl"/>
        </jsp:include>

        <jsp:include page="design-components/atoms/divider/index.jsp">
            <jsp:param name="type" value="top-left theme-color"/>
        </jsp:include>


        <div class="inner-content grid-container">
            <div class="grid-x grid-margin-x grid-padding-y">
                <div class="cell small-12">
                    <h1>Digitale samlingerne</h1>
                    <form id="form" class="form-inline">
                        <div class="form-group">
                            <select class="selectpicker form-control" name="editions" id="editions">
                            </select>
                        </div>
                        <div class="form-group">

                            <input type="text" placeholder="Search (comma separated)" class="form-control" id="query">
                        </div>
                        <div class="form-group">
                            <input type="text" placeholder="Not before YYYY-MM-DD" class="form-control" id="notBefore">
                        </div>
                        <div class="form-group">
                            <input type="text" placeholder="Not after YYYY-MM-DD" class="form-control" id="notAfter">
                        </div>

                        <button type="submit" class="btn btn-default">Submit</button>
                    </form>
                </div>
                <div class="cell small-12">
                    <div class="grid-x grid-margin-x">
                        <div class=" cell small-1">
                            <h3>JSON</h3>
                        </div>
                        <div class="cell small-11">
                            <jsp:include page="design-components/molecules/float-label-input/index.jsp">
                                <jsp:param name="id" value="json"/>
                                <jsp:param name="placeholder" value="Use the search bar to get URL"/>
                            </jsp:include>
                        </div>
                    </div>
                    <div class="grid-x grid-margin-x">
                        <div class=" cell small-1">
                            <h3>RSS</h3>
                        </div>
                        <div class="cell small-11">
                            <jsp:include page="design-components/molecules/float-label-input/index.jsp">
                                <jsp:param name="id" value="rss"/>
                                <jsp:param name="placeholder" value="Use the search bar to get URL"/>
                            </jsp:include>
                        </div>
                    </div>
                    <div class="grid-x grid-margin-x">
                        <div class=" cell small-1">
                            <h3>KML</h3>
                        </div>
                        <div class="cell small-11">
                            <jsp:include page="design-components/molecules/float-label-input/index.jsp">
                                <jsp:param name="id" value="kml"/>
                                <jsp:param name="placeholder" value="Use the search bar to get URL"/>
                            </jsp:include>
                        </div>
                    </div>
                    <div class="grid-x grid-margin-x">
                        <div class=" cell small-1">
                            <h3>MODS</h3>
                        </div>
                        <div class="cell small-11">
                            <jsp:include page="design-components/molecules/float-label-input/index.jsp">
                                <jsp:param name="id" value="mods"/>
                                <jsp:param name="placeholder" value="Use the search bar to get URL"/>
                            </jsp:include>
                        </div>
                    </div>
                </div>
                <div class="cell small-12">
                    <br>
                    <div id="total" class="total"></div>
                    <div class="pagination"></div>
                    <div id="content"></div>
                </div>
            </div>
        </div>
        </div>
    </body>

    <script>
        var pagination;
        var testserver = "http://distest-03.kb.dk:8080";
        var opserver = "http://api.kb.dk/";

        function getData(currentPage) {
            //Display the url
            var url = "rest/api/cop?itemsPerPage=30"
                + "&id=" + $('#editions').val()
                + "&query=" + $('#query').val()
                + "&after=" + $('#notAfter').val()
                + "&before=" + $('#notBefore').val()
                + "&page=" + currentPage;

            var url2 = "http://www.kb.dk/cop/syndication" + $('#editions').val() + "?itemsPerPage=30&query=" + $('#query').val() + "&page=" + currentPage + "&notBefore=" + $('#notBefore').val() + "&notAfter=" + $('#notAfter').val();
            $("#json").val(testserver + url);

            $("#rss").val(url2 + "&format=rss");
            $("#mods").val(url2 + "&format=mods");
            $("#kml").val(url2 + "&format=kml");

            $.ajax({
                dataType: "json",
                url: url,
                contentType: 'application/json; charset=utf-8',
                success: function (data, textStatus, response) {
                    $('#total').html('Total number of items: ' + response.getResponseHeader('total'));
                    var html = '';
                    $.each(data, function (i, row) {
                        html += ' <div class="responsive"><div class="gallery">' +
                            '<a target="_blank" href="' + row['link'] + '/da">' +
                            '<img src="' + row['imageURI'] + '"></a> ' +
                            '<div class="desc">' + row['title'] + '</div>' +
                            '</div>' +
                            '</div>';
                    });
                    $('#content').html(html);
                    //initialise the pagination
                    if (pagination == null) {
                        initializePagination(response.getResponseHeader('Pagination-Count'));
                    }
                },
                error: function () {
                    $('#content').html('<div class="alert alert-info"><strong>Sorry</strong> No data available, have you selected an edition?</div>');
                }
            });
        }
        ;

        function getEditions() {
            $.ajax({
                dataType: "json",
                url: "rest/api/editions",
                success: function (data) {
                    var html = ' <option value="">Select an edition</option>';
                    $.each(data, function (i, row) {
                        html += ' <option value="' + row['identifier'] + '">' + row['title'] + '</option>';
                    });
                    $('#editions').html(html);
                }
            });
        }

        function initializePagination(totalPage) {
            if (pagination != null && totalPage != pagination.pagination('getPagesCount')) {
                pagination.pagination('updateItems', totalPage);
            } else {
                pagination = $('.pagination').pagination({
                    pages: totalPage,
                    cssStyle: 'light-theme',
                    onPageClick: function (pageNumber, event) {
                        getData(pageNumber);
                    }
                });
            }
        }

        function getNewDate(year, month, picker) {
            var daysInMonth = new Date(year, month, 0).getDate();
            var oldDate = picker.datepicker('getDate');
            if (oldDate != null) {
                var oldDay = oldDate.getDate();
                if (oldDay > daysInMonth)
                    oldDay = daysInMonth;
                var newDate = new Date(year, month - 1, oldDay, 0, 0, 0);
            } else {
                var newDate = new Date(year, month - 1, 1, 0, 0, 0);
            }
            picker.datepicker('setDate', newDate);
        }

        $(document).ready(function () {
            getEditions();
            $('#editions').on('change', function () {
                pagination = null;
                getData(1);
            })
            $("#form").submit(function (event) {
                pagination = null;
                getData(1);
                event.preventDefault();
            });
            // initialise the copy to clipboard
            new Clipboard('.btn');
            //initialise datepicker
            var dateFormat = 'yy-mm-dd';
            var from = $("#notBefore").datepicker({
                dateFormat: dateFormat,
                defaultDate: "+1w",
                changeMonth: true,
                changeYear: true,
                yearRange: "1000:-nn",
                numberOfMonths: 1,
                firstDay: 1,
                onChangeMonthYear: function (year, month, datePicker) {
                    getNewDate(year, month, from);
                }
            });
            var to = $("#notAfter").datepicker({
                dateFormat: dateFormat,
                defaultDate: "+1w",
                changeMonth: true,
                changeYear: true,
                yearRange: "1000:-nn",
                numberOfMonths: 1,
                firstDay: 1,
                onChangeMonthYear: function (year, month, datePicker) {
                    getNewDate(year, month, to);
                }
            });
        });
    </script>

</html>
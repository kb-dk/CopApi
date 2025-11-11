<html>
    <head>
        <title>API Digital collections</title>
        <meta charset="utf-8"/>

        <!-- JQUERY -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>




        <!-- BOOTSTRAP -->
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
              integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
              crossorigin="anonymous">

        <!-- Latest compiled and minified JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
                integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
                crossorigin="anonymous"></script>




        <!-- CLIPBOARD -->
        <script src="js/clipboard.min.js"></script>
        <!-- CLIPBOARD -->
        <script src="js/clipboard.min.js"></script>

        <%--<link type="text/css" rel="stylesheet" href="css/style.css"/>--%>
        <link type="text/css" rel="stylesheet" href="css/kbdk-styles.css"/>
        <link type="text/css" rel="stylesheet" href="css/custom.css"/>
    </head>

    <body class="theme-yellow">

        <jsp:include page="design-components/organisms/header/index.jsp">
            <jsp:param name="active" value="cop"/>
        </jsp:include>

        <jsp:include page="design-components/atoms/divider/index.jsp">
            <jsp:param name="type" value="top-left theme-color"/>
        </jsp:include>


        <div class="inner-content grid-container">
            <div class="grid-x grid-margin-x grid-padding-y">
                <div class="cell small-12">
                    <h1>Digital collections</h1>
                    <p>See our collection on this website <a target="blank" href="http://www.kb.dk/editions/any/2009/jul/editions/da/">her</a></p>
                    <div class="starter-template">
                        <div class="row">
                            <form id="form" class="form-inline">
                                <div class="form-group">
                                    <select class="selectpicker form-control" name="editions" id="editions">
                                    </select>
                                </div>
                                <div class="form-group">

                                    <input type="text" placeholder="Search (comma separated)" class="form-control"
                                           id="query" >
                                </div>
                                <div class="form-group">
                                    <input type="text" placeholder="Not before YYYY-MM-DD" class="form-control"
                                           id="notBefore" autocomplete="off">
                                </div>
                                <div class="form-group">
                                    <input type="text" placeholder="Not after YYYY-MM-DD" class="form-control"
                                           id="notAfter" autocomplete="off">
                                </div>

                                <button type="submit" class="btn btn-default">Submit</button>
                            </form>
                        </div>
                        <div id="url">
                            <div class="input-group">
                                <span class="input-group-addon input-group-addon-text">JSON</span>
                                <input id="json" class="form-control url" placeholder="Use the search bar to get URL">
                                <span class="btn input-group-addon" data-clipboard-target="#json">
                           <img class="clippy" src="/data/css/images/clippy.svg" alt="Copy to clipboard">
                        </span>
                            </div>
                            <div class="input-group">
                                <span class="input-group-addon input-group-addon-text">RSS</span>
                                <input id="rss" class="form-control url" placeholder="Use the search bar to get URL">
                                <span class="btn input-group-addon" data-clipboard-target="#rss">
                           <img class="clippy" src="/data/css/images/clippy.svg" alt="Copy to clipboard">
                        </span>
                            </div>
                            <div class="input-group">
                                <span class="input-group-addon input-group-addon-text">KML</span>
                                <input id="kml" class="form-control url" placeholder="Use the search bar to get URL">
                                <span class="btn input-group-addon" data-clipboard-target="#kml">
                           <img class="clippy" src="/data/css/images/clippy.svg" alt="Copy to clipboard">
                        </span>
                            </div>
                            <div class="input-group">
                                <span class="input-group-addon input-group-addon-text">MODS</span>
                                <input id="mods" class="form-control url" placeholder="Use the search bar to get URL">
                                <span class="btn input-group-addon" data-clipboard-target="#mods">
                           <img class="clippy" src="/data/css/images/clippy.svg" alt="Copy to clipboard">
                        </span>
                            </div>

                        </div>
                        <br>
                        <div id="total" class="total"></div>
                        <div class="pagination"></div>
                        <div id="content"></div>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script src="js/scripts.js"></script>
    <!-- PAGINATION -->
    <script type="text/javascript" src="js/jquery.simplePagination.js"></script>
    <link type="text/css" rel="stylesheet" href="css/simplePagination.css"/>
    <script type="text/javascript" src="js/jquery-ui.min.js"></script>
    <link type="text/css" rel="stylesheet" href="css/jquery-ui.min.css"/>

    <script>
        var pagination;
       // var server = "http://distest-03.kb.dk:8080/data/";

	var server = "https://api.kb.dk";
	/*
	"<%=new java.net.URL(request.getScheme(),request.getServerName(),request.getServerPort(),request.getContextPath()) %>";
	*/


        function getData(currentPage) {
            //Display the url
            var url = "/data/rest/api/cop?itemsPerPage=30"
                + "&id=" + $('#editions').val()
                + "&query=" + $('#query').val()
                + "&after=" + $('#notAfter').val()
                + "&before=" + $('#notBefore').val()
                + "&page=" + currentPage;

            var url2 = "https://cop.kb.dk/cop/syndication" + $('#editions').val() + "?itemsPerPage=30&query=" + $('#query').val() + "&page=" + currentPage + "&notBefore=" + $('#notBefore').val() + "&notAfter=" + $('#notAfter').val();
            $("#json").val(url);

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
                url:  "/data/rest/api/editions",
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
    <%-- KB.DK Design javascripts--%>

</html>

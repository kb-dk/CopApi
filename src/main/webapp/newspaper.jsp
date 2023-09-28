<%--
  Created by IntelliJ IDEA.
  User: victor
  Date: 9/28/23
  Time: 11:03 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>API Aerial photographs</title>
    <link rel="shortcut icon" href="favicon.ico"/>

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


    <!-- LEAFLET -->
    <link rel="stylesheet" href="css/leaflet.css"/>
    <link rel="stylesheet" href="css/MarkerCluster.css"/>
    <script src="js/leaflet.js"></script>
    <script src="js/leaflet.markercluster-src.js"></script>
    <script src="js/spin.min.js"></script>
    <script src="js/leaflet.spin.min.js"></script>


    <!-- Cookie script -->
    <script src="http://cookie-script.com/s/903181bb69e77c4a5adfc4ea71d034aa.js"></script>

    <!-- CLIPBOARD -->
    <script src="js/clipboard.min.js"></script>

    <%--<link type="text/css" rel="stylesheet" href="css/style.css"/>--%>
    <link type="text/css" rel="stylesheet" href="css/kbdk-styles.css"/>
    <link type="text/css" rel="stylesheet" href="css/custom.css"/>


</head>

<body class="theme-yellow" >

<jsp:include page="design-components/organisms/header/index.jsp">
    <jsp:param name="active" value="text"/>
</jsp:include>
<div class="inner-content grid-container">
    <div class="grid-x grid-margin-x grid-padding-y">
        <div class="cell small-12">
            <h1>Newspaper API</h1>
            <div class="starter-template">
                <div>
                    <p>Below you can find the full specification for the newspaper API.</p>
                </div>
                <div>
                    <h2>Full OpenAPI specification</h2>
                    <embed src="http://labs.statsbiblioteket.dk/labsapi/api//api-docs?url=/labsapi/api/openapi.yaml" width="100%" height="600">
                </div>
            </div>
        </div>
        <br/>
        <div id="content"></div>
        <div id="spinner"></div>
    </div>
</div>
</body>

<script>
    var xhr;
    var server = "https://api.kb.dk";


    function getData() {
        //Display the url
        addAnd = false;
        var queryParameters = [];
        var url = "/data/rest/api/text?q=";
        if ($('#query').val() != '') {
            queryParameters.push($('#query').val());
        }

        if ($('#cat_ssi').val() != '') {
            if ($('#cat_ssi').val() == 'leaf') {
                queryParameters.push("type_ssi:" + $('#cat_ssi').val());
            }else {
                queryParameters.push("cat_ssi:" + $('#cat_ssi').val());
            }
        }

        if ($('#genre_ssi').val() != '') {
            queryParameters.push("genre_ssi:" + $('#genre_ssi').val());
        }
        if ($('#Sub_collections').val() != '') {
            queryParameters.push("subcollection_ssi:" + $('#Sub_collections').val());
        }
        if ($('#Authors').val() != '') {
            queryParameters.push("author_name_tesim:" + $('#Authors').val());
        }
        url = url + queryParameters.join(' AND ') + "&sort=" + $('#sort').val() + "&rows=" + ($('#rows').val()) + "&start=" + ($('#start').val());

        $("#json").val(server + url + "&wt=json&indent=on");
        //$("#xml").val(server + url + "&wt=xml&indent=on");
        //$("#csv").val(server + url + "&wt=csv&indent=on");

        //Get data
        xhr = $.ajax({
            dataType: "json",
            url: url,
            contentType: 'application/json; charset=utf-8',
            success: function (data, textStatus, response) {
                $('#total').html('Total number of items: ' + response.getResponseHeader('total'));
                var html = '';
                $.each(data.response.docs, function (i, row) {

                    // url = "http://text-test.kb.dk/text/";
                    if(row.type_ssi == 'leaf' && row.part_of_ssim){url += row.part_of_ssim[0] + '#' + row.page_id_ssi; } else { if(row.type_ssi == 'leaf'){url="";}else{url += row.id;}}
                    //if (url != ""){html += '<a href="' + url + '" target="_blank">';}
                    html += '<div class="document">' ;
                    if (row.work_title_tesim != null) {html += "<div><b>Title: </b>" + row.work_title_tesim.join(" ")+"</div>";}
                    if (row.volume_title_tesim != null) {html += "<div><b>Volume title: </b>" + row.volume_title_tesim.join(" ")+"</div>";}
                    if (row.author_nasim != null) {html += "<div><b>Author: </b>" + row.author_nasim.join(" ")+"</div>";}
                    if (row.text_tesim != null) {html += "<div class='text'><b>Text: </b>" + row.text_tesim.join(" ")+"</div>";}
                    html += '</div>';
                    if (url != ""){html += '</a>';}

                });

                if (html == '') {
                    html = '<div class="alert alert-info">No data</div>';
                }

                $('#content').html(html);
            },
            error: function () {
                $('#content').html('<div class="alert alert-info"><strong>Sorry</strong> No data available</div>');
            }
        });
    }
</script>
</html>

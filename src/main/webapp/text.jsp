<html>
<head>
    <title>KB API Demo</title>
    <meta charset="utf-8"/>

    <!-- JQUERY -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>

    <!-- BOOTSTRAP -->
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
          crossorigin="anonymous">

    <!-- CLIPBOARD -->
    <script src="js/clipboard.min.js"></script>

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"
          integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"
          crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>

    <link type="text/css" rel="stylesheet" href="css/style.css"/>

</head>

<body>
    <jsp:include page="header.jsp">
        <jsp:param name="active" value="text"/>
    </jsp:include>

<div class="container">
    <div class="starter-template">
        <div class="row">
            <form id="form" class="form-inline" action="http://index-test.kb.dk/solr/text-retriever-core/select/?q" target="_blank">

                <div class="form-group big_search_box">
                    <input type="text" placeholder="Search" class="form-control" id="query" name="q">
                </div>
                <div class="form-group">
                    <select class="selectpicker form-control" name="author_nasim" id="Authors">
                    </select>
                </div>

                <div class="form-group">
                    <select class="selectpicker form-control" name="cat_ssi" id="cat_ssi">
                        <option value="">Select a category</option>
                        <option value="editorial">editorial</option>
                        <option value="work">work</option>
                        <option value="volume">volume</option>
                        <option value="leaf">leaf</option>
                    </select>
                </div>

                <div class="form-group">
                    <select class="selectpicker form-control" name="genre_ssi" id="genre_ssi">
                        <option value="">Select a genre</option>
                        <option value="prose">prose</option>
                        <option value="play">play</option>
                        <option value="poetry">poetry</option>
                    </select>
                </div>

                <div class="form-group">
                    <select class="selectpicker form-control" name="sort" id="sort">
                        <option value="position_ssi asc">Sort by the order in the book</option>
                        <option value="">Sort by relevance</option>
                    </select>
                </div>

                <div class="form-group">

                    <input type="text"  class="small form-control" id="start" name="start" value="0">
                </div>
                <div class="form-group">

                    <input type="text"  class="small form-control" id="rows" name="rows" value="10">
                </div>

                <input name="indent" type="hidden" value="on"/>
                <input name="defType" type="hidden" value="edismax"/>


                <button type="submit" class="space_on_top btn btn-default">Submit</button>
            </form>
        </div>
        <div id="url">
            <div class="input-group">
                <span class="input-group-addon input-group-addon-text">JSON</span>
                <input id="json" class="form-control url" placeholder="Use the search bar to get URL">
                <span class="btn input-group-addon" data-clipboard-target="#json">
                           <img class="clippy" src="images/clippy.svg" alt="Copy to clipboard">
                        </span>
            </div>
            <div class="input-group">
                <span class="input-group-addon input-group-addon-text">XML</span>
                <input id="xml" class="form-control url" placeholder="Use the search bar to get URL">
                <span class="btn input-group-addon" data-clipboard-target="#xml">
                           <img class="clippy" src="images/clippy.svg" alt="Copy to clipboard">
                        </span>
            </div>
            <div class="input-group">
                <span class="input-group-addon input-group-addon-text">CSV</span>
                <input id="csv" class="form-control url" placeholder="Use the search bar to get URL">
                <span class="btn input-group-addon" data-clipboard-target="#csv">
                           <img class="clippy" src="images/clippy.svg" alt="Copy to clipboard">
                </span>
            </div>

            <br/>
            <div id="content"></div>

        </div>
    </div>
</div>
</body>

<script>
    var xhr;
    function getData() {
        //Display the url
        addAnd = false;
        var queryParameters = [];
        var url = "rest/api/text?q=";
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
        if ($('#Authors').val() != '') {
            queryParameters.push("author_name_tesim:" + $('#Authors').val());
        }

        url = url + queryParameters.join(' and ') + "&sort=" + $('#sort').val() + "&rows=" + ($('#rows').val()) + "&start=" + ($('#start').val());

        $("#json").val("http://labs.kb.dk/" + url + "&wt=json&indent=on");
        $("#xml").val("http://labs.kb.dk/" + url + "&wt=xml&indent=on");
        $("#csv").val("http://labs.kb.dk/" + url + "&wt=csv&indent=on");

        //Get data
        xhr = $.ajax({
            dataType: "json",
            url: url,
            contentType: 'application/json; charset=utf-8',
            success: function (data, textStatus, response) {
                $('#total').html('Total number of items: ' + response.getResponseHeader('total'));
                var html = '';
                console.log(data);
                $.each(data.response.docs, function (i, row) {
                    //debugger;
                    url = "http://adl.dk/solr_documents/";
                    if(row.type_ssi == 'leaf' && row.part_of_ssim){url += row.part_of_ssim[0] + '#' + row.page_id_ssi; } else { if(row.type_ssi == 'leaf'){url="";}else{url += row.id;}}
                    if (url != ""){html += '<a href="' + url + '" target="_blank">';}
                    html += '<div class="document">' ;
                    if (row.work_title_tesim != null) {html += "<div><b>Title: </b>" + row.work_title_tesim.join(" ")+"</div>";}
                    if (row.author_nasim != null) {html += "<div><b>Volume title: </b>" + row.volume_title_tesim.join(" ")+"</div>";}
                    if (row.volume_title_tesim != null) {html += "<div><b>Author: </b>" + row.author_nasim.join(" ")+"</div>";}
                    if (row.text_tesim != null) {html += "<div class='text'><b>Text: </b>" + row.text_tesim.join(" ")+"</div>";}
                    html += '</div>';
                    if (url != ""){html += '</a>';}

                });
                $('#content').html(html);
            },
            error: function () {
                $('#content').html('<div class="alert alert-info"><strong>Sorry</strong> No data available</div>');
            }
        });
    }

    function getAuthors() {
        $.ajax({
            dataType: "json",
            url: "rest/api/text?q=cat_ssi%3Aauthor+AND+type_ssi%3Awork&wt=json&start=0&rows=75&defType=edismax",
            success: function (data) {
                var html = ' <option value="">Select an author</option>';
                $.each(data.response.docs, function (i, row) {

                    html += ' <option value="' + row['author_name_tesim'] + '">' + titleCase(row['author_name_ssi']) + '</option>';
                    console.log(titleCase(row['sort_title_ssi']));
                });
                $('#Authors').html(html);
            }
        });
    }
    function titleCase(str) {
        str = str.toLowerCase().split(' ');
        for (var i = 0; i < str.length; i++) {
            str[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1);
        }
        return str.join(' ');
    }

    $(document).ready(function () {
        getAuthors();
        $("#form").submit(function (event) {
            getData();
            event.preventDefault();
        });
        // initialise the copy to clipboard
        new Clipboard('.btn');

        $("#cat_ssi").change(function() {

            var el = $(this) ;

            if(el.val() == "leaf" || el.val() == "" ) {
                $("#genre_ssi").show();
            }
            else {
                $("#genre_ssi").hide();
            }
        });

    });
</script>

</html>
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
    <jsp:param name="active" value="adl2"/>
</jsp:include>

<div class="container">
    <div class="starter-template">
        <div class="row">
            <form id="form" class="form-inline" action="http://index-prod-01.kb.dk:8983/solr/adl-core/select/?q" target="_blank">

                <div class="form-group">
                    <input type="text" placeholder="Search (comma separated)" class="form-control" id="query" name="q">
                </div>
                <div class="form-group">
                    <input type="text" placeholder="id of a work or volume" class="form-control" id="part_of_ssim" name="part_of_ssim">
                </div>
                <div class="form-group">
                    <select class="selectpicker form-control" name="cat_ssi" id="cat_ssi">
                        <option value="">Select a category</option>
                        <option value="editorial">editorial</option>
                        <option value="work">work</option>
                        <option value="author">author</option>
                        <option value="volume">volume</option>
                        <option value="period">period</option>
                    </select>
                </div>

                <div class="form-group">
                    <select class="selectpicker form-control" name="type_ssi" id="type_ssi">
                        <option value="">Select a type</option>
                        <option value="trunk">trunk</option>
                        <option value="leaf">leaf</option>
                        <option value="work">work</option>
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
                    <select class="selectpicker form-control" name="subcollection_ssi" id="subcollection_ssi">
                        <option value="">Select a sub collection</option>
                        <option value="authors">authors</option>
                        <option value="periods">periods</option>
                        <option value="texts">texts</option>
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

        </div>
    </div>
</div>
</body>

<script>
    function getData(currentPage) {
        //Display the url
        addAnd = false;
        var queryParameters = [];
        var url = "http://index-prod-01.kb.dk:8983/solr/adl-core/select/?q=";
        if ($('#query').val() != '') {
            queryParameters.push($('#query').val());
        }
        if ($('#part_of_ssim').val() != '') {
            queryParameters.push("part_of_ssim:" + $('#part_of_ssim').val());
        }
        if ($('#cat_ssi').val() != '') {
            queryParameters.push("cat_ssi:" + $('#cat_ssi').val());
        }
        if ($('#type_ssi').val() != '') {
            queryParameters.push("type_ssi:" + $('#type_ssi').val());
        }
        if ($('#genre_ssi').val() != '') {
            queryParameters.push("genre_ssi:" + $('#genre_ssi').val());
        }
        if ($('#subcollection_ssi').val() != '') {
            queryParameters.push("subcollection_ssi:" + $('#subcollection_ssi').val());
        }

        url = url + queryParameters.join(' and ') + "&sort=" + ($('#sort').val()) + "&rows=" + ($('#rows').val()) + "&start=" + ($('#start').val());

        $("#json").val(url + "&wt=json&indent=on");
        $("#xml").val(url + "&wt=xml&indent=on");
        $("#csv").val(url + "&wt=csv&indent=on");
    }

    $(document).ready(function () {
        $("#form").submit(function (event) {
            getData(1);
            event.preventDefault();
        });
        // initialise the copy to clipboard
        new Clipboard('.btn');

    });
</script>

</html>
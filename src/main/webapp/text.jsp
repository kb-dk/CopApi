<%@ page import="dk.kb.copapi.JspLogger" %>
    
<html>
  <head>

    <% String requestURI = request.getRequestURI() + ""; 
       JspLogger logger = new JspLogger();
       logger.debug("text.jsp","initializing " + requestURI);
       %>
    
    <title>API Text collections</title>
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
                <h1>Text collections</h1>
                <p>API access to the textual collections that are available at <a target="blank" href="https://tekster.kb.dk/">tekster.kb.dk</a>. Through the interface below it is possible to construct a query, to extract data from the text collections.</p>

                <h2>Overview of fields</h2>
                <table class="table-striped">
                    <tr>
                        <th>Field</th>
                        <th>Description</th>
                        <th>Example</th>
                    </tr>
                    <tr>
                        <td>Search</td>
                        <td>The search field can be used to search for almost any field or any data in the collection. A query in this field can contain boolean operators like AND, OR and NOT.</td>
                        <td>To find all works about books and coffee query for: books AND coffee.</td>
                    </tr>
                    <tr>
                        <td>Subcollection</td>
                        <td>The subcollection field can be used to limit the corpus to specific subcollections.</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Author</td>
                        <td>Limit the query to works created by specific authors.</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Start</td>
                        <td>Initial value of start is 0, which means that the query returns data from the beginning of the result.</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>rows</td>
                        <td>Initial value of row is 10, which means that the API returns 10 results per query. Start and rows can be combined to implement pagination.</td>
                        <td></td>
                    </tr>
                    </table>
                <br/>

                <!--
                <p>	"Query comprised of <b>id</b>, <b>cat_ssi</b>, <b>type_ssi</b>, <b>genre_ssi</b>, <b>work_title_tesim</b>, <b>volume_title_tesim</b>, <b>author_name_tesim</b>, <b>text_tesim</b> and more which are separeted with 'and'.<br/> <b>id</b> is the ID of the record. It is the TEI file base name, or, unless the record isn't referring to a volume, constructed as a string concatenation of that basename with the sequence of xml:ids identifying the uniq xpath to the content indexed.<br/> <b>cat_ssi</b> can be an empty string or 'work' and is the category of a text. Use when limiting searches to works, omit otherwise.<br/> <b>type_ssi</b> can be 'trunk' or 'leaf' and is Node type in document. A trunk node can be a whole work, a chapter etc, whereas a leaf could a paragraph of prose, a stanza (or strophe) of poetry or a speak in a dialog in a scenic work. <br/> <b>genre_ssi</b> can be 'prose', 'poetry' or 'play' and is genre of a leaf node. Note that this is not the genre of a work, but the structure of the paragraph level markup.<br/> <b>work_title_tesim</b>, <b>volume_title_tesim</b>, <b>author_name_tesim</b> and <b>text_tesim</b> are metadata fields. There are more of them, but they should be self explanatory.<br/> <b>Examples:</b><br/>To find all works: q=cat_ssi:work<br/>To find all works by 'Gustaf Munch-Petersen': q=author_name_tesim:munch and cat_ssi:work<br/>To find all texts in dialogs (<sp> elements) in Text, written by someone called 'Jeppe': q=genre_ssi:play and author_name_tesim:jeppe<br/>To find all texts in dialogs (<sp> elements) in Text, spoken by a character named 'Jeppe': q=genre_ssi:play and speaker_tesim:jeppe<br/>To find all strophes of poetry containing the words hjerte and smerte (heart and agony): q=type_ssi:leaf and genre_ssi:poetry and author_name_tesim:grundtvig and text_tesim:hjerte and text_tesim:smerte<br/>To what characters in the plays by Holberg talks about Mester Erich: q=genre_ssi:play and text_tesim:mester erich and author_name_tesim:holberg"</p>
                -->
                <div class="starter-template">
                    <div class="row">                       
                <form id="form" class="form-inline" action="https://public-index.kb.dk/solr/text-retriever-core/select/?q" target="_blank">

                    <div class="form-group big_search_box">
                        <input type="text" placeholder="Search" class="form-control" id="query" name="q">
                    </div>

                    <div class="form-group">
                        <select class="selectpicker form-control" name="subcollection_ssi" id="Sub_collections">
                        </select>
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

                        <input type="text"  class="small form-control" id="start" name="start" value="0" placeholder="start">
                    </div>
                    <div class="form-group">

                        <input type="text"  class="small form-control" id="rows" name="rows" value="10" placeholder="rows">
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
                           <img class="clippy" src="css/images/clippy.svg" alt="Copy to clipboard">
                        </span>
                </div>
               <!-- <div class="input-group">
                    <span class="input-group-addon input-group-addon-text">XML</span>
                    <input id="xml" class="form-control url" placeholder="Use the search bar to get URL">
                    <span class="btn input-group-addon" data-clipboard-target="#xml">
                           <img class="clippy" src="css/images/clippy.svg" alt="Copy to clipboard">
                        </span>
                </div>
                <div class="input-group">
                    <span class="input-group-addon input-group-addon-text">CSV</span>
                    <input id="csv" class="form-control url" placeholder="Use the search bar to get URL">
                    <span class="btn input-group-addon" data-clipboard-target="#csv">
                           <img class="clippy" src="css/images/clippy.svg" alt="Copy to clipboard">
                </span>
                </div>-->
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
    var xhr = "https://api.kb.dk";
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
        function getSubcollections() {
            $.ajax({
                dataType: "json",
                url: "/data/rest/api/text?q=&rows=0&facet=on&facetfield=subcollection_ssi",
                success: function (data) {
                    var html = ' <option value="">Select a sub collection</option>';
                    $.each(data.facet_counts.facet_fields.subcollection_ssi, function (i, row) {
                        if (i % 2 == 0){
                            var subcol = titleCase(row);
                            if (titleCase(row) == "Adl") subcol= "Arkiv for dansk litteratur";
                            if (titleCase(row) == "Sks") subcol= "Søren Kierkegaard";
                            if (titleCase(row) == "Holberg") subcol= "Ludvig Holbergs";
                            if (titleCase(row) == "Pmm") subcol= "Poul Martin Møllers";	
                            if (titleCase(row) == "Tfs") subcol= "Trykkefrihedens skrifter";

                            html += ' <option value="' + row + '">' + subcol + '</option>';
                        }
                    });
                    $('#Sub_collections').html(html);
                }
            });
        }
        function getAuthors() {
            $.ajax({
                dataType: "json",
                url: "/data/rest/api/text?q=cat_ssi:author+AND+type_ssi:work&wt=json&start=0&rows=75&defType=edismax",
                success: function (data) {
                    var html = ' <option value="">Select an author</option>';
                    $.each(data.response.docs, function (i, row) {

                        html += ' <option value="' + row['work_title_tesim'] + '">' + titleCase(row['inverted_name_title_ssi']) + '</option>';
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

        function reset(){

            $('#content').html('');
        }

        $(document).ready(function () {
            getAuthors();
            getSubcollections();

            $("#form").submit(function (event) {
                reset();
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

<html>
<head>
    <title>KB API Demo</title>
    <meta http-equiv="Content-Type"
          content="text/html;charset=UTF-8"/>
    <!-- JQUERY -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>

    <!-- BOOTSTRAP -->
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
          crossorigin="anonymous">

    <!-- PAGINATION -->
    <script type="text/javascript" src="js/jquery.simplePagination.js"></script>
    <link type="text/css" rel="stylesheet" href="css/simplePagination.css"/>

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

<body id="therootelement">

<jsp:include page="header.jsp">
    <jsp:param name="active" value="adl"/>
</jsp:include>

<div class="container">
    <div style="float:left;width:30%;margin-right: 15px;">
        <h1>ADL text search API</h1>

        <p>This document is a part of <a href="http://www.kb.dk/">Royal
            Danish Library</a>'s APIs, and in particular <a
                href="https://github.com/Det-Kongelige-Bibliotek/access-digital-objects/blob/master/text-corpora.md">The
            documentation on how use our texts</a>. See also <a
                href="https://github.com/Det-Kongelige-Bibliotek/access-digital-objects/blob/master/README.md#licences--legalese">Licences
            &amp; Legalese</a> and
            <a href="https://github.com/Det-Kongelige-Bibliotek/access-digital-objects/blob/master/README.md#caveats">Caveats</a>
        </p>

        <form id="form" action="http://index-prod-01.kb.dk:8983/solr/adl-core/select/adl.jsp" target="_blank">
            <dl>
                <dt>Search for</dt>
                <dd>
	    <textarea id="queryfield" name="q" cols="30" rows="10">
cat_ssi:work
	    </textarea>
                </dd>
                <dt>result format</dt>
                <dd>
                    <select id="format" name="wt">
                        <option value="json">json</option>
                        <option value="xml">xml</option>
                    </select>
                </dd>
                <dt>start record</dt>
                <dd><input name="start" value="0"/></dd>
                <dt>number of records</dt>
                <dd><input name="rows" value="10"/></dd>
                <dt>Query parser</dt>
                <dd>
                    <select id="qeryparser" name="defType">
                        <option value="edismax">edismax</option>
                        <option value="dismax">dismax</option>
                    </select>
                    <input name="indent" type="hidden" value="on"/>
                </dd>
                <dt>
                    <input type="submit" value="Submit"/>
                </dt>
            </dl>
        </form>
    </div>
    <div style="float:left;width:60%;">
        <table>

            <tr>
                <td colspan="3">
                    <h2>ID and Relations fields</h2>
                </td>
            </tr>

            <tr>
                <th style="vertical-align:top;text-align:left;">label</th>
                <th style="vertical-align:top;text-align:left;">description</th>
                <th style="vertical-align:top;text-align:right;">values</th>
            </tr>

            <tr>
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">id</pre>
                </td>
                <td style="vertical-align:top;text-align:left;">The ID
                    of the record. It is the TEI file base name, or, unless the
                    record isn't referring to a volume, constructed as a string
                    concatenation of that basename with the sequence of xml:ids
                    identifying the uniq xpath to the content indexed.
                </td>
            </tr>

            <tr>
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">part_of_ssim</pre>
                </td>
                <td style="vertical-align:top;text-align:left;">Array of IDs
                    of trunk nodes being containers the node at hand. Typically
                    containing
                    <ul>
                        <li>One (or more) work(s) as a parent(s). Works may contain works.</li>
                        <li>A volume as an ancestor</li>
                    </ul>
                </td>
                <td style="vertical-align:top;text-align:right;">
                    <pre class="plain-text">string</pre>
                </td>
            </tr>

            <tr>
                <td colspan="3">
                    <h2>Filter fields</h2>
                </td>
            </tr>

            <tr>
                <th style="vertical-align:top;text-align:left;">label</th>
                <th style="vertical-align:top;text-align:left;">description</th>
                <th style="vertical-align:top;text-align:right;">values</th>
            </tr>
            <tr id="cat_ssi">
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">cat_ssi</pre>
                </td>
                <td style="vertical-align:top;text-align:left;">Category of
                    a text. Use when limiting searches to works, omit
                    otherwise.
                </td>
                <td style="vertical-align:top;text-align:right;">
	    <pre class="plain-text">
work
	    </pre>
                </td>
            </tr>
            <tr id="type_ssi">
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">type_ssi</pre>
                </td>
                <td style="vertical-align:top;text-align:left;">Node type
                    in document. A trunk node can be a whole work, a chapter
                    etc, whereas a leaf could a paragraph of prose, a stanza (or
                    strophe) of poetry or a speak in a dialog in a scenic
                    work.
                </td>
                <td style="vertical-align:top;text-align:right;">
	    <pre class="plain-text">
trunk
leaf
	    </pre>
                </td>
            </tr>

            <tr id="genre_ssi">
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">genre_ssi</pre>
                </td>
                <td style="vertical-align:top;text-align:left;">Genre of a
                    leaf node. Note that this is not the genre of a work, but
                    the structure of the paragraph level markup.
                </td>
                <td style="vertical-align:top;text-align:right;">
	    <pre class="plain-text">
prose
poetry
play
	    </pre>
                </td>
            </tr>

            <tr id="genre_ssi">
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">subcollection_ssi</pre>
                </td>
                <td style="vertical-align:top;text-align:left;">Filter with respect to ADL section</td>
                <td style="vertical-align:top;text-align:right;">
	    <pre class="plain-text">
authors
periods
texts
	    </pre>
                </td>
            </tr>


            <tr>
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">position_isi</pre>
                </td>
                <td style="vertical-align:top;text-align:left;">The position
                    of the current node along the sibling axis of the
                    document. Sorting with respect to this field will guarantee
                    that the result is presented in document order.
                </td>
                <td style="vertical-align:top;text-align:right;">
                    <pre class="plain-text">integer</pre>
                </td>
            </tr>

            <tr>
                <td colspan="3">
                    <h2>Search fields</h2>
                </td>
            </tr>

            <tr>
                <th style="vertical-align:top;text-align:left;">label</th>
                <th style="vertical-align:top;text-align:left;">description</th>
                <th style="vertical-align:top;text-align:right;">values</th>
            </tr>
            <tr>
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">work_title_tesim</pre>
                </td>
                <td rowspan="3" style="vertical-align:top;text-align:left;">Misc. metadata
                    fields. There are more of them, but they should be self
                    explanatory.
                </td>
                <td rowspan="3" style="vertical-align:top;text-align:right;">just plain text</td>
            </tr>
            <tr>
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">volume_title_tesim</pre>
                </td>
            </tr>
            <tr>
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">author_name_tesim</pre>
                </td>
            </tr>
            <tr>
                <td style="vertical-align:top;text-align:left;">
                    <pre class="plain-text">text_tesim</pre>
                </td>
                <td style="vertical-align:top;text-align:left;">The text</td>
                <td style="vertical-align:top;text-align:right;">just plain text</td>
            </tr>
        </table>

        <h2>Examples</h2>

        <dl>
            <dt>Find all works
                <a href="#therootelement"
                   onclick="var content = document.getElementById('all_works').innerHTML; document.getElementById('queryfield').value = content; console.log(content);"><strong>try
                    it!</strong></a>
            </dt>
            <dd>
	  <pre id="all_works">
cat_ssi:work
	  </pre>
            </dd>

            <dt>Find all works by Gustaf Munch-Petersen
                <a href="#therootelement"
                   onclick="var content = document.getElementById('works_by_gustaf_munch_petersen').innerHTML; document.getElementById('queryfield').value = content; console.log(content);"><strong>try
                    it!</strong></a>
            </dt>
            <dd>
	  <pre id="works_by_gustaf_munch_petersen">
author_name_tesim:munch
and
cat_ssi:work
	  </pre>
            </dd>


            <dt>Find all texts in dialogs (&lt;sp&gt; elements) in ADL, written by someone called Jeppe <a
                    href="#therootelement"
                    onclick="var content = document.getElementById('plays_by_jeppe').innerHTML; document.getElementById('queryfield').value = content; console.log(content);"><strong>try
                it!</strong></a></dt>
            <dd>
	  <pre id="plays_by_jeppe">
genre_ssi:play
and
subcollection_ssi:texts
and
author_name_tesim:jeppe
	  </pre>
            </dd>

            <dt>Find all texts in dialogs (&lt;sp&gt; elements) in ADL, spoken by a character named Jeppe <a
                    href="#therootelement"
                    onclick="var content = document.getElementById('spoken_by_jeppe').innerHTML; document.getElementById('queryfield').value = content; console.log(content);"><strong>try
                it!</strong></a></dt>
            <dd>
	  <pre id="spoken_by_jeppe">
genre_ssi:play
and
subcollection_ssi:texts
and
speaker_tesim:jeppe
	  </pre>
            </dd>

            <dt>Find all strophes of poetry containing the words hjerte and smerte (heart and agony) <a
                    href="#therootelement"
                    onclick="var content = document.getElementById('heart_agony').innerHTML; document.getElementById('queryfield').value = content; console.log(content);"><strong>try
                it!</strong></a></dt>
            <dd>
  	  <pre id="heart_agony">
type_ssi:leaf
and
genre_ssi:poetry
and
subcollection_ssi:texts
and
author_name_tesim:grundtvig
and
text_tesim:hjerte
and
text_tesim:smerte
	  </pre>
            </dd>

            <dt>What characters in the plays by Holberg talks about Mester Erich <a href="#therootelement"
                                                                                    onclick="var content = document.getElementById('who_talks_about_erich').innerHTML; document.getElementById('queryfield').value = content; console.log(content);"><strong>try
                it!</strong></a></dt>
            <dd>
	  <pre id="who_talks_about_erich">
genre_ssi:play
and
subcollection_ssi:texts
and
text_tesim:mester erich
and
author_name_tesim:holberg
	  </pre>
            </dd>

            <!--Comment this one as it doesn't work for the time being-->
            <!--<dt><strong>Cannot get joins to work this way, at least</strong>-->
                <!--Find all works by Holberg containing poetry <a href="#therootelement"-->
                                                               <!--onclick="var content = document.getElementById('holberg_poetry').innerHTML; document.getElementById('queryfield').value = content; console.log(content);"><strong>try-->
                    <!--it!</strong></a></dt>-->
            <!--<dd>-->
	  <!--<pre id="holberg_poetry">-->
<!--{!join to=id from=part_of_ssim}author_name_tesim:holberg-->
<!--and genre_ssi:poetry-->
	  <!--</pre>-->
            <!--</dd>-->

        </dl>
    </div>
</div>
</body>

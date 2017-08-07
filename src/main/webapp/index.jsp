<%--
  Created by IntelliJ IDEA.
  User: laap
  Date: 03-05-2017
  Time: 13:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>KB API Demo</title>

    <!-- LEAFLET -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.3/dist/leaflet.css"
          integrity="sha512-07I2e+7D8p6he1SIM+1twR5TIrhUQn9+I6yjqD53JQjFiMf8EtC93ty0/5vJTZGF8aAocvHYNEDJajGdNx1IsQ=="
          crossorigin=""/>
    <link rel="stylesheet" href="css/MarkerCluster.css"/>
    <script src="https://unpkg.com/leaflet@1.0.3/dist/leaflet.js"
            integrity="sha512-A7vV8IFfih/D732iSSKi20u/ooOfj/AGehOKq0f4vLT1Zr2Y+RX7C+w8A1gaSasGtRUZpF/NZgzSAu4/Gc41Lg=="
            crossorigin=""></script>
    <script src="js/leaflet.markercluster-src.js"></script>
    <script src="js/spin.min.js"></script>
    <script src="js/leaflet.spin.min.js"></script>


    <!-- CLIPBOARD -->
    <script src="js/clipboard.min.js"></script>

    <!-- JQUERY -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

    <!-- BOOTSTRAP -->
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
          crossorigin="anonymous">

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
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                    aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#"></a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                <li class="active"><a href="index.jsp">DSFL</a></li>
                <li><a href="cop.html">COP</a></li>
                <li><a href="swagger">Documentation</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <div class="starter-template">

        <div id="url">
            <div class="input-group">
                <span class="input-group-addon input-group-addon-text">JSON</span>
                <input id="json" class="form-control url" placeholder="Use the search bar to get URL">
                <span class="btn input-group-addon" data-clipboard-target="#json">
                           <img class="clippy" src="images/clippy.svg" alt="Copy to clipboard">
                        </span>
            </div>
            <div class="input-group">
                <span class="input-group-addon input-group-addon-text">RSS</span>
                <input id="rss" class="form-control url" placeholder="Use the search bar to get URL">
                <span class="btn input-group-addon" data-clipboard-target="#rss">
                           <img class="clippy" src="images/clippy.svg" alt="Copy to clipboard">
                        </span>
            </div>
            <div class="input-group">
                <span class="input-group-addon input-group-addon-text">KML</span>
                <input id="kml" class="form-control url" placeholder="Use the search bar to get URL">
                <span class="btn input-group-addon" data-clipboard-target="#kml">
                           <img class="clippy" src="images/clippy.svg" alt="Copy to clipboard">
                        </span>
            </div>
            <div class="input-group">
                <span class="input-group-addon input-group-addon-text">MODS</span>
                <input id="mods" class="form-control url" placeholder="Use the search bar to get URL">
                <span class="btn input-group-addon" data-clipboard-target="#mods">
                           <img class="clippy" src="images/clippy.svg" alt="Copy to clipboard">
                        </span>
            </div>

        </div>

        <br>
        <div id="total" class="total"></div>
        <br>
        <div id="map"></div>
    </div>
</div>
</body>

<script>
    var map;
    var geojson;
    var xhr;
    var markers;
    function getData() {
        var bounds = map.getBounds()._northEast.lng + "," + map.getBounds()._northEast.lat + "," + map.getBounds()._southWest.lng + "," + map.getBounds()._southWest.lat;
        if (xhr != null){
            xhr.abort();
        }
        var url =  "http:/labs.kb.dk:8080/copapi/rest/api/dsfl?bbo=" + bounds+ "&itemsPerPage=500";
        var url2 =  "http://www.kb.dk/cop/syndication/images/luftfo/2011/maj/luftfoto/subject203?bbo=" + bounds+ "&itemsPerPage=500&page=1";
        $("#json").val(url);
        $("#rss").val(url2 + "&format=rss");
        $("#mods").val(url2 + "&format=mods");
        $("#kml").val(url2 + "&format=kml");
        xhr = $.ajax({
            dataType: "json",
            url: "rest/api/dsfl?bbo=" + bounds + "&itemsPerPage=500",
            beforeSend: function(){
                map.spin(true);
            },
            success: function (data, textStatus, request) {
                if (geojson != null) {
                    markers.removeLayer(geojson);
                    geojson = null;
                }
                $('#total').html("These are " + data.length + " photos out of " + request.getResponseHeader('Pagination-Count'));
                geojson = L.geoJson(data, {
                    onEachFeature: function (feature, layer) {
                        var popup = L.popup({
                            keepInView: "true",
                            minWidth: 200,
                        }).setLatLng([feature.geometry.coordinates[0], feature.geometry.coordinates[1]])
                            .setContent('<h3>' + feature.properties.name + '</h3><img src="' + feature.properties.thumbnail + '">');
                        layer.bindPopup(popup);
                    }
                });
                if (geojson != null) {
                    markers.addLayer(geojson);
                }
            },
            complete:function(){
                map.spin(false);
            }
        });
    }
    $(document).ready(function () {
        map = L.map('map').setView([55.48, 10.4], 10);
        var OpenStreetMap_BlackAndWhite = L.tileLayer('http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png', {
            maxZoom: 18,
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        }).addTo(map);
        markers = L.markerClusterGroup();
        markers.addTo(map);
        map.on('moveend', function () {
            getData();
        });
        map.on('zoomend', function () {
            getData();
        });
        // initialise the copy to clipboard
        new Clipboard('.btn');
        getData();
    });
</script>

</html>
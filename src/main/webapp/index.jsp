<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html lang="da">
    <head>
        <title>KB API</title>
        <link rel="shortcut icon" href="favicon.ico"/>

        <!-- JQUERY -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

        <!-- LEAFLET -->
        <link rel="stylesheet" href="css/leaflet.css"/>
        <link rel="stylesheet" href="css/MarkerCluster.css"/>
        <script src="js/leaflet.js"></script>
        <script src="js/leaflet.markercluster-src.js"></script>
        <script src="js/spin.min.js"></script>
        <script src="js/leaflet.spin.min.js"></script>


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
                    <h1>Luftfotosamlingen</h1>
                    <div id="url">
                        <div class="grid-x grid-margin-x">
                            <div class=" cell small-1">
                                <h3>JSON</h3>
                            </div>
                            <div class="cell small-11">
                                <jsp:include page="design-components/molecules/float-label-input/index.jsp">
                                    <jsp:param name="id" value="json"/>
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
                                </jsp:include>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="cell small-12">
                    <div id="total" class="total"></div>

                    <div id="map"></div>
                </div>
            </div>
        </div>

        <!--  <jsp:include page="design-components/organisms/footer/index.jsp"/> -->

    </body>

    <script>
        var map;
        var geojson;
        var testserver = "http://distest-03.kb.dk:8080/";
        var opserver = "http://api.kb.dk/";
        var markers;

        function getData() {
            var bounds = map.getBounds()._northEast.lng + "," + map.getBounds()._northEast.lat + "," + map.getBounds()._southWest.lng + "," + map.getBounds()._southWest.lat;

            var url = testserver + "rest/api/dsfl?bbo=" + bounds + "&itemsPerPage=500";
            var url2 = "http://www.kb.dk/cop/syndication/images/luftfo/2011/maj/luftfoto/subject203?bbo=" + bounds + "&itemsPerPage=500&page=1";

            $("#json").val(url);
            $("#rss").val(url2 + "&format=rss");
            $("#mods").val(url2 + "&format=mods");
            $("#kml").val(url2 + "&format=kml");

            $.ajax({
                dataType: "json",
                url: "rest/api/dsfl?bbo=" + bounds + "&itemsPerPage=500",
                beforeSend: function () {
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
                complete: function () {
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
    <%-- KB.DK Design javascripts--%>
    <script src="js/scripts.js"></script>

</html>
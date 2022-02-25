<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html lang="da">
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
                    <h1>Aerial photographs</h1>
                    <p>See our collection on this website <a target="blank" href="http://www5.kb.dk/danmarksetfraluften">her</a></p>

                    <div class="starter-template">
                        <div class="row">
                            <div id="url">
                                <div class="input-group">
                                    <span class="input-group-addon input-group-addon-text">JSON</span>
                                    <input id="json" class="form-control url"
                                           placeholder="Use the search bar to get URL">
                                    <span class="btn input-group-addon" data-clipboard-target="#json">
                                         <img class="clippy" src="css/images/clippy.svg" alt="Copy to clipboard">
                                    </span>
                                </div>
                                <div class="input-group">
                                    <span class="input-group-addon input-group-addon-text">RSS</span>
                                    <input id="rss" class="form-control url"
                                           placeholder="Use the search bar to get URL">
                                    <span class="btn input-group-addon" data-clipboard-target="#rss">
                                        <img class="clippy" src="css/images/clippy.svg" alt="Copy to clipboard">
                                    </span>
                                </div>
                                <div class="input-group">
                                    <span class="input-group-addon input-group-addon-text">KML</span>
                                    <input id="kml" class="form-control url"
                                           placeholder="Use the search bar to get URL">
                                    <span class="btn input-group-addon" data-clipboard-target="#kml">
                                        <img class="clippy" src="css/images/clippy.svg" alt="Copy to clipboard">
                                    </span>
                                </div>
                                <div class="input-group">
                                    <span class="input-group-addon input-group-addon-text">MODS</span>
                                    <input id="mods" class="form-control url"
                                           placeholder="Use the search bar to get URL">
                                    <span class="btn input-group-addon" data-clipboard-target="#mods">
                                         <img class="clippy" src="css/images/clippy.svg" alt="Copy to clipboard">
                                     </span>
                                </div>
                            </div>
                        </div>


                    <div class="cell small-12">
                        <br>
                        <div id="total" class="total"></div>
                        <br>
                        <div id="map"></div>
                    </div>
                </div>
                </div>
            </div>
        </div>
    </body>
    <footer class="global-footer">
        <nav class="container">
          <div class="row">
            <div class="col-sm-6 col-lg-9">
              <p><a href="javascript:void(0)" id="csconsentlink">Cookie Settings</a>
                <br> 
                <a href="https://www.kb.dk/en/privacy-and-personal-data-protection-policy">Privacy and Personal Data Protection Policy</a></p>
            </div>
            <div class="col-sm-6 col-lg-3">
              <div class="logo logo-inverted"></div>
              <div aria-label="hostedby">
                <p>Hosted by Det Kgl. Bibliotek</p>
              </div>
              <div aria-label="e-mail">
                <p><a href="mailto:kb@kb.dk">kb@kb.dk</a></p>
              </div>
              <div class="some-icons">
                <a href="https://www.kb.dk/om-os/foelg-os"><i class="rdl-icons">rdl-facebook</i><span class="sr-only">Følg os på facebook</span></a>
                <a href="https://www.linkedin.com/company/det-kgl-bibliotek/"><i class="rdl-icons">rdl-linkedin</i><span class="sr-only">Følg os på linkedin</span></a>
                <a href="https://www.kb.dk/om-os/foelg-os"><i class="rdl-icons">rdl-twitter</i><span class="sr-only">Følg os på twitter</span></a>
              </div>
            </div>
          </div>
        </nav>
      </footer>
    <script>
        var map;
        var geojson;
        var server = "https://api.kb.dk";
	/*
	"<%=new java.net.URL(request.getScheme(),request.getServerName(),request.getServerPort(),request.getContextPath()) %>";
	*/
        var markers;

        function getData() {
            var bounds = map.getBounds()._northEast.lng + "," + map.getBounds()._northEast.lat + "," + map.getBounds()._southWest.lng + "," + map.getBounds()._southWest.lat;

            var url = server + "/data/rest/api/dsfl?bbo=" + bounds + "&itemsPerPage=500";
            var url2 = "http://www5.kb.dk/cop/syndication/images/luftfo/2011/maj/luftfoto/subject203?bbo=" + bounds + "&itemsPerPage=500&page=1";

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

	    // https://tile.openstreetmap.org/${z}/${x}/${y}.png
	    var BaseURI = 'https://tile.openstreetmap.org/'

            var OpenStreetMap_BlackAndWhite = L.tileLayer( BaseURI + '/bw-mapnik/{z}/{x}/{y}.png', {
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
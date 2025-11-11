package dk.kb.copapi;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import java.io.*;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.ArrayList;

import java.util.List;


//http://localhost:8080/swagger/

@Path("api")
@Api
public class API {

    private static String BASE_URI = "https://cop.kb.dk/cop/";
    private String copURL = BASE_URI + "syndication";
    private String dsflURL =  BASE_URI + "syndication/images/luftfo/2011/maj/luftfoto/subject203?format=kml";
    private String contentURL =  BASE_URI + "content";
    private String navigationURL =  BASE_URI + "navigation";
    private String textURL = "https://public-index.kb.dk/solr/text-retriever-core/select";
    private static Logger logger = LogManager.getLogger(API.class);

    @GET
    @ApiOperation(value = "Get the list of editions and retrieve the identifier of the edition, it is needed for any other call ",
            notes = "Only published editions",
            response = API.class,
            responseContainer = "List<Edition>")
    @Path("editions")
    @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
    public List<Edition> getEditions() {
        List<Edition> editions = new ArrayList<Edition>();

        try {
            URLReader reader = new URLReader();
            Document doc = reader.getDocument(BASE_URI + "editions/editions/any/2009/jul/editions/da");
            doc.getDocumentElement().normalize();

            NodeList nodeList = doc.getElementsByTagName("item");

            for (int i = 0; i < nodeList.getLength(); i++) {

                Node nNode = nodeList.item(i);

                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    Edition edition = new Edition();
                    Element eElement = (Element) nNode;
                    edition.setTitle(eElement.getElementsByTagName("title").item(0).getTextContent());
                    edition.setLink(eElement.getElementsByTagName("link").item(0).getTextContent());
                    edition.setDescription(eElement.getElementsByTagName("description").item(0).getTextContent());

                    //Maybe not the best way to parse?
                    NodeList mods = eElement.getElementsByTagName("identifier");
                    edition.setIdentifier(mods.item(0).getTextContent());
                    edition.setImageURI(mods.item(1).getTextContent());
                    edition.setThumbnailURI(mods.item(2).getTextContent());

                    editions.add(edition);
                }
            }
        } catch (Exception ex) {
	    //            logger.log(Level.SEVERE, ex.toString(), ex);
	    logger.error(ex.toString(), ex);
        }

        return editions;
    }

    @GET
    @ApiOperation(value = "Get a list of items from a specific edition ",
            response = API.class)
    @Path("cop/")
    @Produces(MediaType.APPLICATION_JSON + ";charset=utf-8")
    public Response getItemsInsideEditions(
            @ApiParam(value = "Edition id", name = "id", required = true) @QueryParam("id") String id,
            @ApiParam(value = "Search query", name = "query") @QueryParam("query") String query,
            @ApiParam(value = "Pagination-Page", name = "page") @QueryParam("page") String page,
            @ApiParam(value = "Pagination-Limit", name = "itemsPerPage") @QueryParam("itemsPerPage") String itemsPerPage,
            @ApiParam(value = "default is 1920-01-01, Do not return pictures after this date YYYY-MM-DD", name = "not before") @QueryParam("before") String notBefore,
            @ApiParam(value = "default is 1970-12-31, Do not return pictures before this date YYYY-MM-DD", name = "not after") @QueryParam("after") String notAfter)
            throws Exception {

        List<Edition> editions = new ArrayList<Edition>();

        String totalResults = "unknown";
        String startIndex = "unknown";


        URLReader reader = new URLReader();

        String url = copURL + id + "?format=kml";

        if (page != null) {
            url += "&page=" + page;
        }
        if (itemsPerPage != null) {
            url += "&itemsPerPage=" + itemsPerPage;
        }
        if (query != null) {
            url += "&query=" + URLEncoder.encode(query, "UTF-8");
        }
        if (notBefore != null) {
            url += "&notBefore=" + notBefore;
        }
        if (notAfter != null) {
            url += "&notAfter=" + notAfter;
        }

        Document xmlDocument = reader.getDocument(url);
        XPathFactory factory = XPathFactory.newInstance();
        XPath xPath = factory.newXPath();

        NodeList placemarkList = (NodeList) xPath.compile("//Placemark").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList nameList = (NodeList) xPath.compile("//Placemark/name").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList thumbnailList = (NodeList) xPath.compile("//Placemark/ExtendedData/Data[@name='subjectThumbnailSrc']").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList linkList = (NodeList) xPath.compile("//Placemark/ExtendedData/Data[@name='subjectLink']").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList imageURIList = (NodeList) xPath.compile("//Placemark/ExtendedData/Data[@name='subjectImageSrc']").evaluate(xmlDocument, XPathConstants.NODESET);


        totalResults = (String) xPath.evaluate("//totalResults", xmlDocument);
        itemsPerPage = (String) xPath.evaluate("//itemsPerPage", xmlDocument);
        startIndex = (String) xPath.evaluate("//startIndex", xmlDocument);

        for (int i = 0; i < placemarkList.getLength(); i++) {

            Edition edition = new Edition();
            edition.setThumbnailURI(thumbnailList.item(i).getTextContent());
            edition.setLink(linkList.item(i).getTextContent());
            edition.setTitle(nameList.item(i).getTextContent());
            edition.setImageURI(imageURIList.item(i).getTextContent());
            editions.add(edition);
        }

        int total = Integer.parseInt(totalResults) / Integer.parseInt(itemsPerPage);
        return Response.status(200).
                entity(editions).
                header("Total", totalResults).
                header("Pagination-Count", total).
                header("Pagination-Page", startIndex).
                header("Pagination-Limit", itemsPerPage).build();
    }


    @GET
    @ApiOperation(value = "Get the content of an object ",
            response = API.class)
    @Path("content/")
    @Produces(MediaType.APPLICATION_XML)
    public Response getContent(
            @ApiParam(value = "Edition id", name = "identifier", required = true) @QueryParam("identifier") String identifier,
            @ApiParam(value = "Object id", name = "objectId", required = true) @QueryParam("objectId") String objectId)
            throws Exception {

        URLReader reader = new URLReader();
        String url = contentURL + identifier + objectId;
        Document xmlDocument = reader.getDocument(url);
        return Response.status(200).entity(xmlDocument).build();
    }

    private static String readAll(Reader rd) throws IOException {
        StringBuilder sb = new StringBuilder();
        int cp;
        while ((cp = rd.read()) != -1) {
            sb.append((char) cp);
        }
        return sb.toString();
    }

    @GET
    @ApiOperation(value = "Get the content of text core from solr ",
            response = API.class)
    @Path("text/")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getTextContent(
            @ApiParam(value = "Query comprised of <b>id</b>, <b>cat_ssi</b>, <b>type_ssi</b>, <b>genre_ssi</b>, <b>work_title_tesim</b>, <b>volume_title_tesim</b>, <b>author_name_tesim</b>, <b>text_tesim</b> and more which are separeted with 'and'." +
                    "<br/> <b>id</b> is the ID of the record. It is the TEI file base name, or, unless the record isn't referring to a volume, constructed as a string concatenation of that basename with the sequence of xml:ids identifying the uniq xpath to the content indexed." +
                    "<br/> <b>cat_ssi</b> can be an empty string or 'work' and is the category of a text. Use when limiting searches to works, omit otherwise." +
                    "<br/> <b>type_ssi</b> can be 'trunk' or 'leaf' and is Node type in document. A trunk node can be a whole work, a chapter etc, whereas a leaf could a paragraph of prose, a stanza (or strophe) of poetry or a speak in a dialog in a scenic work. " +
                    "<br/> <b>genre_ssi</b> can be 'prose', 'poetry' or 'play' and is genre of a leaf node. Note that this is not the genre of a work, but the structure of the paragraph level markup." +
                    "<br/> <b>work_title_tesim</b>, <b>volume_title_tesim</b>, <b>author_name_tesim</b> and <b>text_tesim</b> are metadata fields. There are more of them, but they should be self explanatory." +
                    "<br/> <b>Examples:</b>" +
                    "<br/>To find all works: q=cat_ssi:work" +
                    "<br/>To find all works by 'Gustaf Munch-Petersen': q=author_name_tesim:munch and cat_ssi:work" +
                    "<br/>To find all texts in dialogs (<sp> elements) in Text, written by someone called 'Jeppe': q=genre_ssi:play and author_name_tesim:jeppe" +
                    "<br/>To find all texts in dialogs (<sp> elements) in Text, spoken by a character named 'Jeppe': q=genre_ssi:play and speaker_tesim:jeppe" +
                    "<br/>To find all strophes of poetry containing the words hjerte and smerte (heart and agony): q=type_ssi:leaf and genre_ssi:poetry and author_name_tesim:grundtvig and text_tesim:hjerte and text_tesim:smerte" +
                    "<br/>To what characters in the plays by Holberg talks about Mester Erich: q=genre_ssi:play and text_tesim:mester erich and author_name_tesim:holberg", name = "q", required = false) @QueryParam("q") String q,
            @ApiParam(value = "Start record", name = "start", required = false) @QueryParam("start") String start,
            @ApiParam(value = "Number of records to retrieve", name = "rows", required = false) @QueryParam("rows") String rows,
            @ApiParam(value = "Facet needed to retrieve sub collection", name = "facet", required = false) @QueryParam("facetfield") String facetfield,
            @ApiParam(value = "Facet fields needed to retrieve sub collection", name = "facet", required = false) @QueryParam("facet") String facet,
            @ApiParam(value = "defType can be 'dismax' or 'edismax' and is the query parser.", name = "defType", required = false) @QueryParam("defType") String defType,
            @ApiParam(value = "indent can be 'on' or 'off' and is the indentation of the result", name = "indent", required = false) @QueryParam("indent") String indent,
            @ApiParam(value = "Sort can be empty string or 'position_isi'. position_isi is the the position of the current node along the sibling axis of the document. Sorting with respect to this field will guarantee that the result is presented in document order.", name = "sort", required = false) @QueryParam("sort") String sort)
            throws Exception {

        URLReader reader = new URLReader();

	logger.debug("Preparing text query for q = {}", q);
	
        String url = textURL + "?q=" + URLEncoder.encode(q, "UTF-8") + "&wt=json";


        if (start != null) {
            url += "&start=" + start;
	    logger.debug("\tstart = {}", start);
        }

        if (rows != null) {
            url += "&rows=" + rows;
	    logger.debug("\trows = {}", rows);
        }

        if (defType != null) {
            url += "&defType=" + defType;
	    logger.debug("\ttype = {}", defType);
        }

        if (indent != null) {
            url += "&indent=" + indent;
        }

        if (sort != null) {
            url += "&sort=" + URLEncoder.encode(sort, "UTF-8");
        }

        if (facet != null) {
            url += "&facet=" + facet;
        }

        if (facetfield != null) {
            url += "&facet.field=" + facetfield;
	    logger.debug("\tfacet field = {}", facetfield);
        }

	logger.debug("text URI is {}", url);	
	
        InputStream is = new URL(url).openStream();
        try {
            BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));

            String jsonText = readAll(rd);

	    logger.debug("successfully retrieved URI {}", url);	
	    
            return Response.status(200).entity(jsonText).build();
        } catch (Exception ex) {
             logger.error(ex.toString());

        } finally {
            is.close();
        }

        return null;
    }


    @GET
    @ApiOperation(value = "The subject hierarchy needed for filtering and building the browsing service",
            response = API.class)
    @Path("navigation/")
    @Produces(MediaType.APPLICATION_XML)
    public Response getSubjectHierarchy(
            @ApiParam(value = "Edition id", name = "identifier", required = true) @QueryParam("identifier") String identifier,
            @ApiParam(value = "Edition id", name = "subjectId", required = true) @QueryParam("subjectId") String subjectId)
            throws Exception {

        URLReader reader = new URLReader();
        String url = navigationURL + identifier + subjectId;

        System.out.println(url);
        Document xmlDocument = reader.getDocument(url);
        return Response.status(200).entity(xmlDocument).build();
    }

    @GET
    @Path("dsfl/")
    @ApiOperation(value = "Get a list of pictures (url, coordinates and descriptions) inside a bounding box")
    @Produces(MediaType.APPLICATION_JSON + ";charset=utf-8")
    public Response getDSFLPhotos(
            @ApiParam(value = "The bounding box", name = "bbo", required = true) @QueryParam("bbo") String bbo,
            @ApiParam(value = "Pagination-Page", name = "page") @QueryParam("page") String page,
            @ApiParam(value = "Pagination-Limit", name = "itemsPerPage") @QueryParam("itemsPerPage") String itemsPerPage,
            @ApiParam(value = "default is 1920-01-01, Do not return pictures before this date YYYY-MM-DD", name = "notBefore") @QueryParam("notBefore") String notBefore,
            @ApiParam(value = "default is 1970-12-31, Do not return pictures before this date YYYY-MM-DD", name = "notAfter") @QueryParam("notAfter") String notAfter)
            throws Exception {

        Pictures pictures = new Pictures();
        pictures.setType("FeatureCollection");
        String totalResults = "unknown";
        String startIndex = "unknown";
        List<Picture> pictureList = new ArrayList<Picture>();
        URLReader reader = new URLReader();

        if (bbo == null) throw new NotAuthorizedException("BBO is missing");
        String url = dsflURL + "&bbo=" + bbo;

        if (notBefore != null) {
            url += "&notBefore" + notBefore;
        }
        if (notAfter != null) {
            url += "&notAfter" + notAfter;
        }
        if (page != null) {
            url += "&page=" + page;
        }
        if (itemsPerPage != null) {
            url += "&itemsPerPage=" + itemsPerPage;
        }

        Document xmlDocument = reader.getDocument(url);
        XPathFactory factory = XPathFactory.newInstance();
        XPath xPath = factory.newXPath();

        NodeList placemarkList = (NodeList) xPath.compile("//Placemark").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList nameList = (NodeList) xPath.compile("//Placemark/name").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList coordList = (NodeList) xPath.compile("//Placemark/Point/coordinates").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList thumbnailList = (NodeList) xPath.compile("//Placemark/ExtendedData/Data[@name='subjectThumbnailSrc']").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList srcList = (NodeList) xPath.compile("//Placemark/ExtendedData/Data[@name='subjectImageSrc']").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList genreList = (NodeList) xPath.compile("//Placemark/ExtendedData/Data[@name='subjectGenre']").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList subjectCreationDateList = (NodeList) xPath.compile("//Placemark/ExtendedData/Data[@name='subjectCreationDate']").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList geographicList = (NodeList) xPath.compile("//Placemark/ExtendedData/Data[@name='subjectGeographic']").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList recordCreationDateList = (NodeList) xPath.compile("//Placemark/ExtendedData/Data[@name='recordCreationDate']").evaluate(xmlDocument, XPathConstants.NODESET);
        NodeList recordChangeDateList = (NodeList) xPath.compile("//Placemark/ExtendedData/Data[@name='recordCreationDate']").evaluate(xmlDocument, XPathConstants.NODESET);

        totalResults = (String) xPath.evaluate("//totalResults", xmlDocument);
        itemsPerPage = (String) xPath.evaluate("//itemsPerPage", xmlDocument);
        startIndex = (String) xPath.evaluate("//startIndex", xmlDocument);

        for (int i = 0; i < placemarkList.getLength(); i++) {

            Picture picture = new Picture();

            Geometry geometry = new Geometry();
            geometry.setType("Point");
            List<Float> list = new ArrayList<Float>();
            String[] s = coordList.item(i).getTextContent().split(",");
            list.add(Float.parseFloat(s[0]));
            list.add(Float.parseFloat(s[1]));
            geometry.setCoordinates(list);

            picture.setGeometry(geometry);

            Properties properties = new Properties();
            properties.setName(nameList.item(i).getTextContent());
            properties.setThumbnail(thumbnailList.item(i).getTextContent());
            properties.setSrc(srcList.item(i).getTextContent());
            properties.setGenre(genreList.item(i).getTextContent());
            properties.setGeographic(geographicList.item(i).getTextContent());
            properties.setSubjectCreationDate(subjectCreationDateList.item(i).getTextContent());
            properties.setRecordCreationDate(recordCreationDateList.item(i).getTextContent());
            properties.setRecordChangeDate(recordChangeDateList.item(i).getTextContent());

            picture.setProperties(properties);

            picture.setType("Feature");

            pictureList.add(picture);
        }

        pictures.setFeatures(pictureList);

        return Response.status(200).
                entity(pictureList).
                header("Pagination-Count", totalResults).
                header("Pagination-Page", startIndex).
                header("Pagination-Limit", itemsPerPage).build();
    }
}

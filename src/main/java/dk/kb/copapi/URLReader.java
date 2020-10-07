package dk.kb.copapi;

import org.w3c.dom.Document;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.net.URL;
import java.net.URLConnection;
import java.net.HttpURLConnection;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.io.*;

/**
 * Created by laap on 03-05-2017.
 */
public class URLReader {

    private static Logger logger = LogManager.getLogger(URLReader.class);
    
    public Document getDocument(String url) throws Exception {

        DocumentBuilderFactory docfact = DocumentBuilderFactory.newInstance();
        docfact.setNamespaceAware(false);
        docfact.setValidating(false);
        DocumentBuilder docbuilder = null;
        docbuilder = docfact.newDocumentBuilder();
        HttpURLConnection urlConnection = (HttpURLConnection)(new URL(url).openConnection());

	urlConnection.addRequestProperty("Accept", "application/xml");
	
	InputStream stream = urlConnection.getInputStream();
	Document doc = docbuilder.parse(stream);

	String status = urlConnection.getResponseMessage();
	if(status != null ) {
	    logger.info("Get {} for URI = {}",status,url);
	}
	
        return doc;
    }
}


    

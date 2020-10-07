package dk.kb.copapi;

import org.w3c.dom.Document;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.net.URL;
import java.net.URLConnection;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Created by laap on 03-05-2017.
 */
public class URLReader {

    private static Logger logger = LogManager.getLogger(URLReader.class);
    
    public Document getDocument(String url) throws Exception {

        DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
        f.setNamespaceAware(false);
        f.setValidating(false);
        DocumentBuilder b = null;
        b = f.newDocumentBuilder();
        URLConnection urlConnection = new URL(url).openConnection();

	String status = null; //urlConnection.getHeaderField("Status");
	if(status != null ) {
	    logger.info("Get {} for URI = {}",status,url);
	}
	
        urlConnection.addRequestProperty("Accept", "application/xml");
        return b.parse(urlConnection.getInputStream());
    }
}


    

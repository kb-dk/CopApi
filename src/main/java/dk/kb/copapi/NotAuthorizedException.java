package dk.kb.copapi;

import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


/**
 * Created by laap on 09-05-2017.
 */
public class NotAuthorizedException extends WebApplicationException {
    private static Logger logger = LogManager.getLogger(NotAuthorizedException.class);

    public NotAuthorizedException(String message) {
        super(Response.status(Response.Status.UNAUTHORIZED)
                .entity(message).type(MediaType.TEXT_PLAIN).build());
	logger.error(message);	
    }
}

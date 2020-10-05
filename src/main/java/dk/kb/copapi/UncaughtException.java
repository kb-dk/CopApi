package dk.kb.copapi;

/**
 * Created by laap on 09-05-2017.
 */
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


@Provider
public class UncaughtException extends Throwable implements ExceptionMapper<Throwable>
{
    private static final long serialVersionUID = 1L;
    private static Logger logger = LogManager.getLogger(API.class);

    public Response toResponse(Throwable ex) {
	logger.error(ex.toString(), ex);
        return Response.status(500).entity("Sorry, an error has occurred. are you sure that you have the correct parameters?").type("text/plain").build();
    }
}

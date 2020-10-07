package dk.kb.copapi;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
 
public class JspLogger
{
    private static Logger logger = LogManager.getLogger(JspLogger.class);

    public class RunPull {}
    
    public void debug(String jsp, String msg)
    {        
        logger.debug("JSP {} reports {}",jsp,msg);
    }

    public void info(String jsp, String msg)
    {        
        logger.info("JSP {} informs {}",jsp,msg);
    }

    public void error(String jsp, String msg)
    {        
        logger.error("JSP {} report error {}",jsp,msg);
    }

    public void warn(String jsp, String msg)
    {        
        logger.warn("JSP {} warns {}",jsp,msg);
    }
}


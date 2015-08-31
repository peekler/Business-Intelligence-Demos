package hu.bme.aut.bi.voterestful;

import org.glassfish.jersey.servlet.ServletContainer;
import org.glassfish.jersey.servlet.WebConfig;

import javax.servlet.ServletException;

/**
 * Created by Peter on 28/08/2015.
 */
public class BaseServlet extends ServletContainer {
    @Override
    protected void init(WebConfig webConfig) throws ServletException {
        super.init(webConfig);
        // Init goes here...
    }
}

package hu.bme.aut.bi.restfulbase;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.codehaus.jackson.map.ObjectMapper;

import java.net.URI;
import java.util.List;

import javax.ws.rs.core.Response.Status;
import javax.ws.rs.core.UriInfo;


@Path("/")
public class BaseSite {
    @GET
    @Path("/test")
    @Produces("text/plain")
    public String demo() {
        return "Demo";
    }
}
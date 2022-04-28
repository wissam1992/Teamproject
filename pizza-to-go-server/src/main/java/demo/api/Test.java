package demo.api;

import javax.inject.Singleton;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;


@Singleton
public class Test {
    

    @GET
    @Path("/test")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getTest(){
        return Response.ok("Das hat funktioniert!").build();
    }


}

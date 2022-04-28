package demo.model.secured;

import demo.model.user.Person;
import demo.model.user.PersonDao;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;
import javax.transaction.Transactional;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("secured")
@RequestScoped
public class ProfileData {
    @Inject
    private PersonDao personDao;

    // loads user info with parameter app/secured/{user}
    @GET
    @Path("{user}")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response getPerson(@PathParam("user") String username) {
        return Response.ok("Message Decrypted! " + username).entity(personDao.findUsername(username)).build();

    }

    /**
     * This method returns the existing/stored persons in Json format
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public JsonArray getPersons() {
        JsonObjectBuilder builder = Json.createObjectBuilder();
        JsonArrayBuilder finalArray = Json.createArrayBuilder();
        for (Person person : personDao.readAllPersons()) {
            builder.add("firstname", person.getFirstname()).add("lastname", person.getLastname())
                    .add("username", person.getUsername()).add("email", person.getEmail());
            finalArray.add(builder.build());
        }
        return finalArray.build();
    }
}

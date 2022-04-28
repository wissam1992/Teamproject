package demo.model.user;

import app.api.security.PasswordEncrypt;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.json.*;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.util.Base64;
import java.util.Base64.Encoder;

@RequestScoped
@Path("users")
public class UserResource {
    @Inject
    private PersonDao personDao;

    /**
     * This method creates a new user from the submitted data (firstname, lastname,
     * username, password, email, address) by the user.
     */
    @POST
    @Path("add")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @Transactional
    public Response addPerson(@FormParam("firstname") String firstname, @FormParam("lastname") String lastname,
            @FormParam("username") String username, @FormParam("password") String password,
            @FormParam("email") String email, @FormParam("address") String address) {
        Person person = new Person(firstname, lastname, username, password, email, address);

        Response addPersonTest = addPersonTest(person);
        return addPersonTest;
    }

    // TEST Person add
    @POST
    @Path("add-person")
    @Consumes(MediaType.APPLICATION_JSON)
    @Transactional
    public Response addPersonTest(Person person) {
        // Person person = new Person(firstname, lastname, username, password, email,
        // address);

        // encryption
        byte[] salt;
        try {
            salt = PasswordEncrypt.getSalt();
        } catch (NoSuchAlgorithmException | NoSuchProviderException e) {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }
        String pw = person.getPassword();
        person.setPassword(PasswordEncrypt.getSecurePassword(pw, salt));
        Encoder encoder = Base64.getUrlEncoder().withoutPadding();
        String token = encoder.encodeToString(salt);
        // save encoded salt token
        person.setSalt(token);

        if (!personDao.findPerson(person.getUsername(), person.getEmail()).isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST).entity("User already exists").build();
        }
        personDao.createPerson(person);
        return Response.status(Response.Status.OK).build();
    }

    /**
     * This method returns a specific existing/stored event in Json format
     */
    @GET
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public JsonObject getPerson(@PathParam("id") int persId) {
        JsonObjectBuilder builder = Json.createObjectBuilder();
        Person person = personDao.readPerson(persId);
        if (person != null) {
            builder.add("firstname", person.getFirstname()).add("lastname", person.getLastname())
                    .add("username", person.getUsername()).add("email", person.getEmail())
                    .add("address", person.getAddress());
        }
        return builder.build();
    }

    @GET
    @Path("{username}")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public JsonObject getPersonUsername(@PathParam("username") String username) {
        JsonObjectBuilder builder = Json.createObjectBuilder();
        Person person = personDao.findUsername(username);
        if (person != null) {
            builder.add("firstname", person.getFirstname()).add("lastname", person.getLastname())
                    .add("username", person.getUsername()).add("email", person.getEmail())
                    .add("address", person.getAddress());
        }
        return builder.build();
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

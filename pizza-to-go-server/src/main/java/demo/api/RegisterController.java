package demo.api;

import demo.api.security.AccessManager;
import demo.model.user.Person;

import javax.inject.Inject;
import javax.inject.Singleton;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.NewCookie;
import javax.ws.rs.core.Response;
import java.util.UUID;

@Path("/register")
@Singleton
public class RegisterController
{

   @Inject
   AccessManager accessController;

   @Inject
   PersonManager pManager;

   @POST
   @Consumes(MediaType.APPLICATION_JSON)
   public Response register(Person user)
   {     
      try
      {
         this.pManager.register(user);
         UUID uuid = this.accessController.login(user.getUsername());
         NewCookie loginCookie = new NewCookie("LoginID", uuid.toString());
         return Response.status(200).cookie(loginCookie).build();
         // return Response.ok("Created!").build();
      }
      catch (Exception exce)
      {
         System.out.println("ERROR " + exce.getMessage() );
         return Response.status(404).build();
      }
   }
}

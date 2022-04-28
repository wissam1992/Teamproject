package demo.api;

import app.api.security.PasswordEncrypt;
import demo.api.security.AccessManager;
import demo.model.user.Person;

import javax.inject.Inject;
import javax.inject.Singleton;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.NewCookie;
import javax.ws.rs.core.Response;
import java.util.Base64;
import java.util.Optional;
import java.util.UUID;

@Path("/login")
@Singleton
public class LoginController
{
   @Inject
   AccessManager accessManager;

   @Inject
   PersonManager pManager;


   @POST
   @Consumes(MediaType.APPLICATION_JSON)
   public Response login(Person user)
   {    
      String pass ="";
      try
      {
         Optional<Person> optUser = this.pManager.lookupUser(user.getUsername());
         //Optional<Person> optUser = this.pManager.lookupUser("user");
         if( optUser.isPresent() )
         {
            pass = decodePW(user,optUser.get().getSalt());
            user.setPassword(pass);
            //Check Password
            if( user.getPassword().equals( optUser.get().getPassword()) == false )
            // if( user.getPassword().equals( "password") == false )
            {
               throw new RuntimeException("Wrong Password");
            }
            
            //Login
            UUID uuid = this.accessManager.login(user.getUsername());
            NewCookie loginCookie = new NewCookie("LoginID", uuid.toString());
            return Response.status(200).cookie(loginCookie).build();
         }
         else
         {
            throw new RuntimeException("User not known");
         }
      }
      catch (Exception exce)
      {
         System.out.println("ERROR " + exce.getMessage() );
         return Response.status(404).build();
      }
   }

   private String decodePW(Person user,String saltU) {
      byte[] salt = Base64.getUrlDecoder().decode(saltU.getBytes());
      String pw = PasswordEncrypt.getSecurePassword(user.getPassword(),salt);
      Response.ok("password"+pw).build();
      return pw;
   }

   // @GET
   // @Path("check")
   // @Consumes(MediaType.APPLICATION_JSON)
   // @Transactional
   // public Response checkLogin(@CookieParam("LoginID") String loginId)
   // {
   //    String details = "Keine Nachricht";
   //    try {
   //       boolean isLoggedIn = accessManager.isLoggedIn(UUID.fromString(loginId));
   //       Optional<String> username = accessManager.getLoginName(UUID.fromString(loginId));
   //       if (isLoggedIn) {
   //          return Response.ok().entity(username.get().getId()).build();
   //       } else {
   //          return Response.ok().entity(-1).build();
   //       }
   //    } catch (Exception e) {
   //       System.out.println(e.getMessage());
   //    }
   //     return Response.ok().entity(details).build();

   // }

   @Path("/id")
   @Produces(MediaType.APPLICATION_JSON)
   public Response getID(@CookieParam("LoginID") String loginId)
   {
      // Access-controll
      UUID  uuid = UUID.fromString(loginId);
      if( this.accessManager.isLoggedIn(uuid) == false )
      {
         System.out.println("ERROR Access not allowed");
         return Response.status(404, "Not logged in").build();
      }
      
      Optional<String> username = accessManager.getLoginName( UUID.fromString(loginId) );
      if(  username.isPresent() == false )
      {
         System.out.println("ERROR Username not found");
         return Response.status(403, "User not found").build();
      }
      
      // Check user
      Optional<Person> optUser = pManager.lookupUser(username.get());
     
      if( optUser.isPresent() == false )
      {
         System.out.println("ERROR User not found");
         return Response.status(404, "User not found").build();
      }
     
      try {
      return Response.ok().entity(optUser.get().getId()).build();
     } catch (Exception e) {  
      e.printStackTrace();
     }
      return Response.status(404).build();
   }

   @DELETE
   @Consumes(MediaType.APPLICATION_JSON)
   public Response logout(@CookieParam("LoginID") String loginId)
   {
      try
      {
         this.accessManager.logout(UUID.fromString(loginId) );
         return Response.status(200).cookie( (NewCookie) null).build();
      }
      catch (Exception exce)
      {
         System.out.println("ERROR " + exce.getMessage() );
         return Response.status(404).build();
      }
   }
}

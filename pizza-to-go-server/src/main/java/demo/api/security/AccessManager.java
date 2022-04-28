package demo.api.security;

import javax.inject.Singleton;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;


@Singleton
public class AccessManager
{
   private Map<UUID, String> logins = new HashMap<>();

   public AccessManager()
   {
      super();
   }
   
   public boolean isLoggedIn(UUID loginID)
   {
      return this.logins.containsKey(loginID);
   }
   
   public Optional<String> getLoginName(UUID loginID)
   {
      String loginname = this.logins.get(loginID);
      if( loginname != null )
      {
         return Optional.of(loginname);
      }
      else
      {
         return Optional.empty();
      }
   }
   
   
   public UUID login(String loginname)
   {
      if( this.logins.containsValue(loginname) )
      {
         RuntimeException exce = new RuntimeException("ERROR: User is already logged in");
         throw exce;
      }
      
      UUID uuid = UUID.randomUUID();
      this.logins.put( uuid, loginname );
      return uuid;
   }
   
   public void logout(UUID loginID)
   {
      if( this.logins.containsKey(loginID) == false )
      {
         RuntimeException exce = new RuntimeException("User was not logged in");
         throw exce;
      }
      
      this.logins.remove( loginID );
      return;
   }
}

package demo.api;

import demo.model.user.Person;
import demo.model.user.PersonDao;

import javax.inject.Inject;
import javax.inject.Singleton;
import java.util.Optional;

@Singleton
public class PersonManager {

    @Inject
    PersonDao personDao;

    public PersonManager() {
        super();
    }

    public Optional<Person> lookupUser(String username) {
        Optional<Person> op = Optional.of(personDao.findUsername(username));
         return op;
    }

    public void register(Person user)
   {
      if( this.lookupUser( user.getUsername() ).isPresent() )
      {
         RuntimeException exce = new RuntimeException("User " + user + " already exists!");
         throw exce;
      }
      else
      {
         String username = user.getUsername();
         this.personDao.createPerson(user);
         return;
      }
   }
}

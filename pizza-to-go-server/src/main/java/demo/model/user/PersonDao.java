package demo.model.user;

import javax.enterprise.context.RequestScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;


@RequestScoped
public class PersonDao {
    @PersistenceContext(name = "jpa-unit")
    private EntityManager em;

    public void createPerson(Person person){
        em.persist(person);
    }

    public Person readPerson(int persId){
        return em.find(Person.class, persId);
    }

    public void updatePerson(Person person){
        em.merge(person);
    }

    public void deletePerson(Person person){
        em.remove(person);
    }

    public List<Person> readAllPersons(){
        return em.createQuery("Person.findAll", Person.class).getResultList();
    }

    public List<Person> findPerson(String username, String email) {
        return em.createNamedQuery("Person.findPerson", Person.class)
            .setParameter("username", username)
            .setParameter("email", email).getResultList();
    }

    public Person findUsername(String username) {
        return em.createNamedQuery("Person.findPersonUsername", Person.class)
            .setParameter("username", username).getSingleResult();
    }

    public EntityManager getEm() {
        return em;
    }
    
}

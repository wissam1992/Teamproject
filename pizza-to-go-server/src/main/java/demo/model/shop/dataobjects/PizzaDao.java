package demo.model.shop.dataobjects;

import demo.model.ref.MyDataObject;
import demo.model.shop.entities.Pizza;

import javax.enterprise.context.RequestScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@RequestScoped
public class PizzaDao implements MyDataObject<Pizza>{
    @PersistenceContext(name = "jpa-unit")
    private EntityManager em;

    @Override
    public void create(Pizza pizza){
        em.persist(pizza);
    }

    @Override
    public Pizza read(int pizzaId){
        return em.find(Pizza.class, pizzaId);
    }

    @Override
    public void update(Pizza pizza){
        em.merge(pizza);
    }

    @Override
    public void delete(Pizza pizza){
        em.remove(pizza);
    }

    @Override
    public List<Pizza> readAll(){
        return em.createNamedQuery("Pizza.findAll", Pizza.class).getResultList();
    }

    @Override
    public Pizza findByName(String name) {
        return em.createNamedQuery("Pizza.findPizzaName", Pizza.class)
            .setParameter("name", name)
            .getSingleResult();
    }
    
    @Override
    public EntityManager getEm() {
        return em;
    }

}

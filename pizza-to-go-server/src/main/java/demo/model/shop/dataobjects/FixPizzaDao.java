package demo.model.shop.dataobjects;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import demo.model.ref.MyDataObject;
import demo.model.shop.entities.FixPizza;

public class FixPizzaDao implements MyDataObject<FixPizza> {
    @PersistenceContext(name = "jpa-unit")
    private EntityManager em;

    @Override
    public void create(FixPizza entity) {
        em.persist(entity);

    }

    @Override
    public FixPizza read(int id) {
        return em.find(FixPizza.class, id);
    }

    @Override
    public void update(FixPizza entity) {
        em.merge(entity);
    }

    @Override
    public void delete(FixPizza entity) {
        em.remove(entity);

    }

    @Override
    public List<FixPizza> readAll() {
        return em.createNamedQuery("FixPizza.findAll", FixPizza.class).getResultList();
    }

    @Override
    public FixPizza findByName(String name) {
        return em.createNamedQuery("FixPizza.findPizzaName", FixPizza.class)
            .getSingleResult();
    }

    @Override
    public EntityManager getEm() {
        return em;
    }

    
}

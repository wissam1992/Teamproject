package demo.model.shop.dataobjects;

import demo.model.ref.MyDataObject;
import demo.model.shop.entities.Orders;

import javax.enterprise.context.RequestScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@RequestScoped
public class OrdersDao implements MyDataObject<Orders>{
    @PersistenceContext(name = "jpa-unit")
    private EntityManager em;
    
   @Override
    public List<Orders> readAll(){
        return em.createNamedQuery("Orders.findAll", Orders.class).getResultList();
    }

    @Override
	public EntityManager getEm() {
		return em;
	}

    @Override
    public void create(Orders entity) {
        em.persist(entity);
    }

    @Override
    public Orders read(int id) {
        return em.find(Orders.class, id);

    }

    @Override
    public void update(Orders entity) {
        em.merge(entity);

    }

    @Override
    public void delete(Orders entity) {
        em.remove(entity);

    }

    @Override
    public Orders findByName(String name) {
        return em.createNamedQuery("Orders.findByUsername", Orders.class)
            .setParameter("name", name)
            .getSingleResult();
    }

    public List<Orders> findByUsername(String username) throws IllegalStateException{
        return em.createNamedQuery("Orders.findByUsername", Orders.class)
        .setParameter("username", username)
        .getResultList();
    }
}
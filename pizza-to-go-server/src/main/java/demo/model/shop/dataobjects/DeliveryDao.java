package demo.model.shop.dataobjects;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;

import demo.model.ref.MyDataObject;
import demo.model.shop.entities.Delivery;

public class DeliveryDao implements MyDataObject<Delivery> {

    @PersistenceContext(name = "jpa-unit")
    private EntityManager em;
    
    @Override
    public void create(Delivery entity) {
       em.persist(entity);

    }

    @Override
    public Delivery read(int id) {
        return em.find(Delivery.class, id);
    }

    @Override
    public void update(Delivery entity) {
        em.merge(entity);

    }

    @Override
    public void delete(Delivery entity) {
        em.remove(entity);

    }

    @Override
    public List<Delivery> readAll() {
        try {
            return em.createNamedQuery("Delivery.findAll", Delivery.class).getResultList();
        } catch (NoResultException e) {
            System.out.println("Delivery ERROR : "+e.getMessage());
           return null;
        }
    }

    @Override
    public Delivery findByName(String name){
        try {
            return em.createNamedQuery("Delivery.findByName", Delivery.class)
                .setParameter("name", name)
                .getSingleResult();
        } catch (NoResultException e) {
            System.out.println("Delivery ERROR : "+e.getMessage());
           return null;
        }
    }
    
    public Delivery findByOrderId(int id){
        try {
            return em.createNamedQuery("Delivery.findByOrderId", Delivery.class)
                .setParameter("orderId", id)
                .getSingleResult();
        } catch (NoResultException e) {
            System.out.println("Delivery ERROR : "+e.getMessage());
           return null;
        }
    }

    public List<Delivery> findByOrderIdList(int id){
        try {
            return em.createNamedQuery("Delivery.findByOrderId", Delivery.class)
                .setParameter("orderId", id)
                .getResultList();
        } catch (NoResultException e) {
            System.out.println("Delivery ERROR : "+e.getMessage());
           return null;
        }
    }

    @Override
    public EntityManager getEm() {
        return em;
    }
    
}

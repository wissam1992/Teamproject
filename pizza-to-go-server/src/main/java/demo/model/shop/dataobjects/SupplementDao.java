package demo.model.shop.dataobjects;

import demo.model.ref.MyDataObject;
import demo.model.shop.entities.Supplement;

import javax.enterprise.context.RequestScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@RequestScoped
public class SupplementDao implements MyDataObject<Supplement> {
    @PersistenceContext(name = "jpa-unit")
    private EntityManager em;

    @Override
    public void create(Supplement supp) {
        em.persist(supp);
    }

    @Override
    public Supplement read(int suppId) {
        return em.find(Supplement.class, suppId);
    }

    @Override
    public void update(Supplement supp) {
        em.merge(supp);
    }

    @Override
    public void delete(Supplement supp) {
        em.remove(supp);
    }

    @Override
    public List<Supplement> readAll() {
        return em.createNamedQuery("Supplement.findAll", Supplement.class).getResultList();
    }

    @Override
    public Supplement findByName(String name) {
        return em.createNamedQuery("Supplement.findSuppName", Supplement.class).setParameter("name", name)
                .getSingleResult();
    }

    @Override
    public EntityManager getEm() {
        return em;
    }
}

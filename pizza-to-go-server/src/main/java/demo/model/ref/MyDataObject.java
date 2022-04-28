package demo.model.ref;

import java.util.List;

import javax.persistence.EntityManager;

public interface MyDataObject<MyEntity> {
    public void create(MyEntity entity);
    public MyEntity read(int id);
    public void update(MyEntity entity);
    public void delete(MyEntity entity);
    public List<MyEntity> readAll();
    public MyEntity findByName(String name);
    public EntityManager getEm();
}

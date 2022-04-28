package demo.model.shop.entities;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import demo.model.ref.DatabaseEntity;

@Entity
@Table(name = "FixPizza")
@NamedQuery(name = "FixPizza.findAll", query = "SELECT p FROM FixPizza p")
@NamedQuery(name = "FixPizza.findPizzaName", query = "SELECT p FROM FixPizza p WHERE p.name = :name")
public class FixPizza implements DatabaseEntity{
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Id
    @Column(name = "pizzaId")
    private int id;

    @Column(name = "Name")
    private String name;

    @Column(name = "imagePath")
    private String imagePath; 	

    @Column(name = "description")
    private String description; 

    @ElementCollection
    private Map<String,Double> prices = new HashMap();


    public FixPizza() {
    }

    public FixPizza(String name, String imagePath, String description, Map<String,Double> prices) {
        this.name = name;
        this.imagePath = imagePath;
        this.description = description;
        this.prices = prices;
    }


    public int getId() {
        return this.id;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImagePath() {
        return this.imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Map<String,Double> getPrices() {
        return this.prices;
    }

    public void setPrices(Map<String,Double> prices) {
        this.prices = prices;
    }


    @Override
    public String toString() {
        return "{" +
            " id='" + getId() + "'" +
            ", name='" + getName() + "'" +
            ", imagePath='" + getImagePath() + "'" +
            ", description='" + getDescription() + "'" +
            ", prices='" + getPrices() + "'" +
            "}";
    }

}

package demo.model.shop.entities;

import com.fasterxml.jackson.annotation.JsonBackReference;

import demo.model.ref.DatabaseEntity;

import javax.json.Json;
import javax.persistence.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "Supplement")
@NamedQuery(name = "Supplement.findAll", query = "SELECT s FROM Supplement s")
@NamedQuery(name = "Supplement.findSuppName", query = "SELECT s FROM Supplement s WHERE s.name = :name")
public class Supplement implements DatabaseEntity {

	@GeneratedValue(strategy = GenerationType.AUTO)
	@Id
	@Column(name = "suppId")
	private int id;

	@Column(name = "name")
	private String name;

	@Column(name = "imagePath")
	private String imagePath;

	@Column(name = "price")
    private double price; 

	@JsonBackReference
	@ManyToMany(mappedBy = "supplements")
	private List<Pizza> pizzas = new ArrayList<>();

	public Supplement() {
	}

	public Supplement(String name) {
		this.name = name;

	}

	public Supplement(String name, String imagePath, double price) {
		this.name = name;
		this.imagePath = imagePath;
		this.price = price;
	}

	public void setPizzas(List<Pizza> pizzas) {
		this.pizzas = pizzas;
	}

	public List<Pizza> getPizzas() {
		return this.pizzas;
	}

	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public boolean equals(Object o) {
		if (o == this)
			return true;
		if (!(o instanceof Supplement)) {
			return false;
		}
		Supplement supplement = (Supplement) o;
		return id == supplement.id && Objects.equals(name, supplement.name);
	}

	@Override
	public int hashCode() {
		return Objects.hash(id, name);
	}

	@Override
	public String toString() {
		return "{" + " id='" + getId() + "'" + ", name='" + getName() + "'" + ", imagePath='" + getImagePath() + "'"
				+ ", price='" + getPrice() + "'" + "}";
	}

	// creates Json String f�r Supp. Ignoriert Attribut List<Pizza>
	public String suppToJsonString() {
		return Json.createObjectBuilder()
				.add("id", this.getId())
				.add("imagePath", this.getImagePath())
				.add("name", this.getName())
				.add("price", this.getPrice())
				.build()
				.toString();		
	}
	
	//gibt einen string im json format aus und nimmt als argument list von supplements
	public static String suppListToJsonString(List<Supplement> list) {
		String result = "[";

		Iterator<Supplement> it = list.iterator();

		while (it.hasNext()) {
			Supplement supp = it.next();

			if (it.hasNext()) {// solange nicht letztes element erreicht, fueghe komma hinzu
				result += supp.suppToJsonString() + ",";
			} else {
				result += supp.suppToJsonString();
			}

		}

		result += "]";

		return result;
	}


	public double getPrice() {
		return this.price;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
	public void setPrice(double price) {
		this.price = price;
	}

	public String getImagePath() {
		return this.imagePath;
	}

}

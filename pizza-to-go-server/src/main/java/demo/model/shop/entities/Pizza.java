package demo.model.shop.entities;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import demo.model.ref.DatabaseEntity;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.persistence.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "Pizza")
@NamedQuery(name = "Pizza.findAll", query = "SELECT p FROM Pizza p")
@NamedQuery(name = "Pizza.findPizzaName", query = "SELECT p FROM Pizza p WHERE p.name = :name")
public class Pizza implements DatabaseEntity{
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Id
    @Column(name = "pizzaId")
    private int id;

    @Column(name = "Name")
    private String name;	//Bsp Maragarita

    @Column(name = "Price")
    private Double price; 	

    //TODO: Anzahl von Pizza 

    @Column(name = "imagePath")
    private String imagePath; 	

    @Column(name = "description")
    private String description; 	

	private int size;	//klein = 1, mittel = 2, gross = 3
    
	@JsonManagedReference
    @ManyToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
    @JoinTable(name = "pizza_supplement", joinColumns = @JoinColumn(name = "pizzaId"), inverseJoinColumns = @JoinColumn(name = "suppId"))
    private List<Supplement> supplements = new ArrayList<>();

    @JsonBackReference
    @ManyToOne(cascade={CascadeType.ALL})
    private Orders order;
    
    public Pizza() {
    }

    public Pizza(String name, int size, double price) {
        this.name = name;
        this.price = price;
        this.size = size;
    }
    
    public Pizza(String name, int size, double price, Orders order) {
        this.name = name;
        this.price = price;
        this.size = size;
    }
    
    public Pizza(String name,  double price, Orders or) {
        this.name = name;
        this.price = price;
    }


    public Pizza(String name, Double price, String imagePath, String description, int size) {
        this.name = name;
        this.price = price;
        this.imagePath = imagePath;
        this.description = description;
        this.size = size;
    }


    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

   
   
    public double getPrice() {
        return this.price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    
    public List<Supplement> getSupplements() {
		return supplements;
	}

	public void setSupplements(List<Supplement> supplements) {
		this.supplements = supplements;
	}


	public void addSupplement(Supplement sup) {
        supplements.add(sup);
        sup.getPizzas().add(this);
    }
    public Orders getOrders() {
		return order;
	}

	public void setOrders(Orders orders) {
		this.order = orders;
	}

	public void removeSupplement(Supplement sup) {
        supplements.remove(sup);
        sup.getPizzas().remove(this);
    }

	@Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof Pizza)) {
            return false;
        }
        Pizza pizza = (Pizza) o;
        return id == pizza.id && Objects.equals(name, pizza.name)
                && price == pizza.price ;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name,price);
    }

    @Override
    public String toString() {
        return "{" +
            " id='" + getId() + "'" +
            ", name='" + getName() + "'" +
            ", price='" + getPrice() + "'" +
            ", imagePath='" + getImagePath() + "'" +
            ", description='" + getDescription() + "'" +
            ", size='" + getSize() + "'" +
            ", supplements='" + getSupplements() + "'" +
            "}";
    }
 
    //erzeugt JsonObject aus this
    public JsonObject createPizzaJsonObject() {
    	//start building a json tree
    	JsonObjectBuilder rootBuilder = Json.createObjectBuilder();
    	rootBuilder.add("id", this.getId())
    			.add("name", this.getName() )
    			.add("price", this.getPrice() )
    			.add("imagePath", this.getPrice() )
    			.add("description", this.getPrice() )
    			.add("size", this.getSize() ) ;
    	
    	JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
    	for(Supplement supp: supplements) {
    		//create json object fuer jeden supplements
    		JsonObjectBuilder supplementBuilder = Json.createObjectBuilder();
            JsonObject supplementJson = supplementBuilder
            .add("name", supp.getName() )
            .add("imagePath", supp.getName() )
            .add("price", supp.getPrice() )
            .build();
    		//fuege es dem array<Supplement> hinzu
    		arrayBuilder.add(supplementJson);
    	}
    	
    	JsonObject root = rootBuilder.add("supplements", arrayBuilder).build();
    	
    	return root;
    	
    }
    
    //erzeugt formatierten JSON-String aus this
    public String toFormattedJsonString() {
		JsonObject jsonObj = this.createPizzaJsonObject();
		String notFormJson = jsonObj.toString();

		ObjectMapper objMap = new ObjectMapper();
		objMap.enable(SerializationFeature.INDENT_OUTPUT);
		
		String json = "";
		try {
			Object obj = objMap.readValue(notFormJson, Object.class);
			json = objMap.writerWithDefaultPrettyPrinter().writeValueAsString(obj);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return json;
		
	}
    
    //erzeugt json-string aus einer liste von pizzen
    public static String pizzaListToJsonString(List<Pizza> list) {
    	String result = "[";
    	
    	Iterator<Pizza> it = list.iterator();
    	while(it.hasNext()) {
    		Pizza pizza = it.next();
    		
    		if(it.hasNext()) 
    			result += pizza.toFormattedJsonString() + ",";
    		else 
    			result += pizza.toFormattedJsonString();
    	}
    	
    	result += "]";
    	
    	return result;
    }


    public String getImagePath() {
        return this.imagePath;
    }

    public String getDescription() {
        return this.description;
    }
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    public void setDescription(String description) {
        this.description = description;
    }


}

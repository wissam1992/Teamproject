package demo.model.shop.entities;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import demo.model.ref.DatabaseEntity;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.persistence.*;

import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

@Entity
@Table(name = "Orders")
@NamedQuery(name = "Orders.findByUsername", query = "SELECT o FROM Orders o WHERE o.username = :username")
@NamedQuery(name = "Orders.findAll", query = "SELECT o FROM Orders o ")
public class Orders implements DatabaseEntity{

	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "orderId")
	private int id;
	
	@Column(name = "username")
	private String username;

	@Column(name = "totalPrice")
	private String totalPrice;

	@Column(name = "address")
	private String address;

	@Column(name = "orderTime")
	private Date orderTime = new Date();

	@JsonManagedReference
	@ManyToMany(cascade = { CascadeType.ALL })
	@JoinColumn(name="PizzaId",nullable=true)
	private List<Pizza> pizzas = new LinkedList<Pizza>();

	public Orders() {
	}
	
	public Orders(String username) {
		this.username = username;
	}


	public Orders(String username, String totalPrice, String address) {
		this.username = username;
		this.totalPrice = totalPrice;
		this.address = address;
	}
	

	public Orders(List<Pizza> piz) {
		this.pizzas = piz;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return id;
	}
	
	public String getUsername() {
		return username;
	}

	public void setName(String username) {
		this.username = username;
	}

	@JsonManagedReference
	public List<Pizza> getPizzas() {
		return pizzas;
	}

	public void setPizzas(List<Pizza> pizzas) {
		this.pizzas = pizzas;
	}

	public void addPizza(Pizza pizza) {
		this.pizzas.add(pizza);
	}

	//erstellt JsonObject von Order. Allerdings noch nicht formatiert
	public JsonObject createOrdersJsonObject() {
		// start building a json tree
		JsonObjectBuilder rootBuilder = Json.createObjectBuilder();
		rootBuilder.add("id", this.getId()).
		add("username", this.getUsername())
		.add("totalPrice", this.getTotalPrice())
		.add("address", this.getAddress())
		.add("orderTime", this.getOrderTime().toString());

		JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
		for (Pizza pizza : pizzas) {
			// create json obj fuer pizza
			JsonObject pizzaJson = pizza.createPizzaJsonObject();

			// fuege es array von pizzen hinzu
			arrayBuilder.add(pizzaJson);
		}

		JsonObject root = rootBuilder.add("pizzas", arrayBuilder).build();

		return root;
	}

	//erstellt aus JsonObject einen formatierten JsonString
	public String toFormattedJsonString() {
		JsonObject jsonObj = this.createOrdersJsonObject();
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
	
	//macht aus einer Liste von orders einen JSON String
	public static String ordersListToJsonString(List<Orders> list) {
		String result = "[";
		
		Iterator<Orders> it = list.iterator();
		while(it.hasNext()) {
			Orders order = it.next();
			
			if(it.hasNext())
				result += order.toFormattedJsonString() + ",";
			else
				result += order.toFormattedJsonString();
		}
		
		result += "]";
		
		return result;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getTotalPrice() {
		return this.totalPrice;
	}

	public void setTotalPrice(String totalPrice) {
		this.totalPrice = totalPrice;
	}

	public Date getOrderTime() {
		return this.orderTime;
	}

	public void setOrderTime(Date orderTime) {
		this.orderTime = orderTime;
	}

	public String getAddress() {
		return this.address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	@Override
	public String toString() {
		return "{" +
			" id='" + getId() + "'" +
			", username='" + getUsername() + "'" +
			", totalPrice='" + getTotalPrice() + "'" +
			", address='" + getAddress() + "'" +
			", orderTime='" + getOrderTime() + "'" +
			", pizzas='" + getPizzas() + "'" +
			"}";
	}
}
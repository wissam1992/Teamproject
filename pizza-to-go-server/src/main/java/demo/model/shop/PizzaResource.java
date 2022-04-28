package demo.model.shop;

import demo.model.shop.dataobjects.FixPizzaDao;
import demo.model.shop.dataobjects.PizzaDao;
import demo.model.shop.entities.FixPizza;
import demo.model.shop.entities.Orders;
import demo.model.shop.entities.Pizza;
import demo.model.shop.entities.Supplement;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.json.JsonObject;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;


@RequestScoped
@Path("pizzas")
public class PizzaResource {
    
    @Inject
    private PizzaDao pizzaDao;

    @Inject
    private FixPizzaDao fixPizzaDao;

    //gibt alle Pizzen in der DB als json aus
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response getPizzas(){
    	List<Pizza> list = pizzaDao.readAll();
    	String listJson = Pizza.pizzaListToJsonString(list);
    	
        return Response.ok().entity(listJson).build();
    }

    //gibt liste aller fixen(standard-pizzen) pizzen als json zurueck
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    @Path("all")
    public Response getAllPizzas(){
    	List<FixPizza> list = fixPizzaDao.readAll();
    	
        return Response.ok().entity(list).build();
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    @Path("all/{idd}")
    public Response getPizzaByIdd(@PathParam("idd") int id){
    	FixPizza list = fixPizzaDao.read(id);
    	// String listJson = FixPizza.pizzaListToJsonString();
    	
        return Response.ok().entity(list).build();
    }

    @POST
    @Path("fix/add")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Transactional
    public Response addPizza(FixPizza pizza){	
    	fixPizzaDao.create(pizza);
        return Response.ok().entity(pizza).build();
    }
    
    //gibt pizza mit pizza.id = pizzaId als json zurueck
    @GET
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response getPizzaById(@PathParam("id") int pizzaId) {
    	Pizza pizza = pizzaDao.read(pizzaId);
    	String jsonString = pizza.toFormattedJsonString();
    	
    	return Response.ok().entity(jsonString).build();
    }
    
    //gibt pizza mit pizza.name = name als json zurueck
    @GET
    @Path("{name}")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response getPizzaByName(@PathParam("name") String name) {
 	   Pizza pizza= pizzaDao.findByName(name);
 	   return Response.ok().entity(pizza.toFormattedJsonString()).build();
    }
    
    
    //fuegt Pizza hinzu und gibt empfangenen json zurueck
    @POST
    @Path("addJson")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Transactional
    public Response addPizza(Pizza pizza){	
    	System.out.println(pizza);
    	System.out.println(pizza.toFormattedJsonString());
        new Orders().addPizza(pizza);
        pizzaDao.create(pizza);
        return Response.ok().entity(pizza.toFormattedJsonString()).build();
    }
    
    //test-methode um json-rueckgabe einer order zu testen
    @GET
    @Path("beleg")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response Supps(){

    //als parameter nehmen wir ID von Pizza und Supplement und die werden in datenbanken gesucht und addiert
    //zwei ids 
    Orders order = new Orders();
    	
    Pizza p1 = new Pizza("p1",1,12.05);
    Pizza p2 = new Pizza("p2",1,12.15);

    Supplement s1 = new Supplement("Tomaten");
    Supplement s2 = new Supplement("Gurken");

    p1.addSupplement(s1);
    p1.addSupplement(s2);
    p2.addSupplement(s2);
 
    order.addPizza(p1);
    order.addPizza(p2);
    

    pizzaDao.getEm().persist(p1);
    pizzaDao.getEm().persist(p2);
    
  
    System.out.println("---------------createOrderJson-------------------");
   	JsonObject jsonObj = order.createOrdersJsonObject();
   	String jsonString = order.toFormattedJsonString();
   	System.out.println(jsonString);
   
   
   	return Response.ok().entity(jsonString).type(MediaType.APPLICATION_JSON).build();
    }

}

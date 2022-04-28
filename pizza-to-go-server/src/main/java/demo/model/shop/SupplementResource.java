package demo.model.shop;

import demo.model.shop.dataobjects.SupplementDao;
import demo.model.shop.entities.Supplement;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@RequestScoped
@Path("supp")
public class SupplementResource {
     
    @Inject
    private SupplementDao suppDao;

    
    //initialisiert die DB mit 8 supplements
    @GET
    @Path("initDB")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response initDB() {
    	Supplement kaeSupplement = new Supplement("Kaese","",0.8);
    	Supplement tomatenso = new Supplement("Tomatensose","",0.8);
    	Supplement schinken= new Supplement("Schinken","",0.8);
    	Supplement salami= new Supplement("Salami","",0.8);
    	Supplement pilze = new Supplement("Pilze","",0.8);
    	Supplement zwiebel= new Supplement("Zwiebel","",0.8);
    	Supplement pepperoni= new Supplement("Pepperoni","",0.8);
    	Supplement thunfisch = new Supplement("Thunfisch","",0.8);

 	
    	suppDao.create(kaeSupplement);
    	suppDao.create(tomatenso);
    	suppDao.create(schinken);
    	suppDao.create(salami);
    	suppDao.create(pilze);
    	suppDao.create(zwiebel);
    	suppDao.create(pepperoni);
    	suppDao.create(thunfisch);
    	
    	return Response.ok().build();
    	
    }
    
    //gibt alle supplements als JSON aus
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response getSupplements(){
    	List<Supplement> list = suppDao.readAll();
    	String jsonResult = Supplement.suppListToJsonString(list);
    	
        return Response.ok().entity(jsonResult).build();
    }

    
    //gibt supplements mit  suppId = {id} als json aus
    @GET
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response getSupplementById(@PathParam("id") int suppId) {
    	Supplement supp = suppDao.read(suppId);
    	String jsonString = supp.suppToJsonString();
    	
    	return Response.ok().entity(jsonString).build();
    }
    
    
   //gibt supp mit suppName = {name} als json aus
   @GET
   @Path("{name}")
   @Produces(MediaType.APPLICATION_JSON)
   @Transactional
   public Response getSupplementByName(@PathParam("name") String name) {
	   Supplement supp = suppDao.findByName(name);
	   return Response.ok().entity(supp.suppToJsonString()).build();
   }
   
   // bsp POST ../app/supp/Tomaten gibt JSON-String fuer Entitaet Tomaten aus
    @POST
    @Path("add")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response addPizza(
        @FormParam("name") String name, @FormParam("imagePath") String path, @FormParam("price") double price
    ){
        Supplement supp = new Supplement(name,path, price);
        suppDao.create(supp);
        return Response.ok().entity(supp.suppToJsonString()).build();
    }

}

package demo.model.pizzaProduktion;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.enterprise.context.RequestScoped;
import javax.transaction.Transactional;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.google.gson.Gson;

import demo.model.beschaffungswesen.Nachbestellung;
import demo.model.ref.DeliveryStatus;
import demo.model.ref.PaymentStatus;
import demo.model.shop.entities.Delivery;
import demo.model.shop.entities.Orders;

@RequestScoped
@Path("pizza-produktion")
public class PizzaProduktion {

	
	//bekommt ein order obj uebergeben und wandelt es in auftrag um. auftrag wird dann auf koncole ausgegeben
	@POST
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON)
	@Transactional
	public Response addOrder(Orders order) {
		//10s Produktionszeit
		try{
			Thread.sleep(10000);
		}catch(InterruptedException e) {
			e.printStackTrace();
		}
		System.out.println("Pizzaproduktion fertig");
		
		//sende an delivery
		sendOrderViaPostToURL(order, "http://localhost:9080/pizza-to-go-server/app/delivery/add", true);
		
		//sende an beschaffungswesen
    	sendOrderViaPostToURL(order,"http://localhost:9080/pizza-to-go-server/app/beschaffungswesen", false);
    	
		return Response.ok().entity(order).build();
	}
	
	//wandelt order in nachbestellung um und sendet zu beschaffungswesen api
	//fall dilevery == true, wird order in delivery umgewandelt, ansonsten in nachbestllung
	private void sendOrderViaPostToURL(Orders order, String URLString, boolean delivery) {
		HttpURLConnection con;
		OutputStream os = null;
		String line;

		try {
    		//create url to beschaffungswesen
    		URL url =new URL(URLString);
    		
    		//open connection
    		con = (HttpURLConnection) url.openConnection();
    		
    		//set response format type
    		con.setRequestProperty("Accept", "application/json");
    		con.setRequestProperty("Content-Type", "application/json");
    		//set method
    		con.setRequestMethod("POST");
    		con.setDoOutput(true);
    		con.setDoInput(true);
    		
    		String gson;
    		if(delivery) {//falls es sich um delivery handelt
    			Delivery d = new Delivery(order.getUsername(), order.getId(), DeliveryStatus.ORDERED, PaymentStatus.CASH_ON_DELIVERY);
    			gson = new Gson().toJson(d);
    		}else {
    			//erzeuge nachbestellung
        		gson = new Gson().toJson(Nachbestellung.createNachbestellung(order));
        		System.out.println("Gson-Nachbestellung:\n" + gson);
    		}
    		
    		//write output to beschaffungswesen api
    		os = con.getOutputStream();
    		os.write(gson.getBytes());
    		os.close();
    		
    		//check ResponseCode
    		System.out.println("Beschaffungswesen-Response-Code: " + con.getResponseCode());
    	}catch(Exception e) {
    		e.printStackTrace();
    	}finally {
    		if(os != null)
				try {
					os.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
    	}
	}

	
	//zaehlt die anzahl der supplemente in der bestellung o und setzt die entstehenden werte (supp,anzahl) 
	//in die hashMap ein
	public void calcSupplementsToDeliver(Orders o) {
		HashMap<String, Integer> suppCounts = new HashMap<String,Integer>();
		
		//gehe jedes supp durch
		o.getPizzas().forEach(pizza -> pizza.getSupplements()
					 .forEach(supp -> {
						//schaue, welcher wert an stelle von suppNahme steht 
						int count = ( suppCounts.get(supp.getName()) == null) ? 0 : suppCounts.get(supp.getName()); 
						System.out.println(suppCounts.put(supp.getName(), ++count));
					 }
					 ));
		
		//asugabe auf konsole durch entrySet
		Iterator it = suppCounts.entrySet().iterator();
		while(it.hasNext()) {
			Map.Entry<String,Integer> pair = (Map.Entry<String, Integer>)it.next();
			System.out.println(pair.getKey() + " = " + pair.getValue());
			it.remove();
		}
	}
	
}

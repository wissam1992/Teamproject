package demo.model.beschaffungswesen;

import java.io.IOException;
import java.util.List;

import javax.transaction.Transactional;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.google.gson.Gson;

import demo.model.shop.entities.Orders;
import demo.model.shop.log.LogFileProcessor;

@Path("beschaffungswesen")
public class Beschaffungswesen {

	//nimmt nachbestellung entgegen und loggt sie in provision.log
	@POST
	@Consumes(MediaType.APPLICATION_JSON)
	@Transactional
	public Response addNachbestellung(Nachbestellung bestellung) {
		String gson = new Gson().toJson(bestellung);

		LogFileProcessor fileProcessor = LogFileProcessor.getInstance();

		//hier wird die Bestellung in einer Datei "provision.log" gespeichert
		try {
			fileProcessor.executeService(fileProcessor.createFileLog(bestellung));
		} catch (IOException e) {
			System.out.println(e.getMessage());
		}
		return Response.ok().entity(gson).build();
	}
	
}

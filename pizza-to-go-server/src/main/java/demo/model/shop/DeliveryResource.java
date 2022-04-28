package demo.model.shop;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.json.Json;
import javax.transaction.Transactional;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import demo.model.ref.DeliveryStatus;
import demo.model.ref.PaymentStatus;
import demo.model.shop.dataobjects.DeliveryDao;
import demo.model.shop.log.LogFileProcessor;
import demo.model.shop.entities.Delivery;
import demo.model.shop.log.DeliverySystem;

@RequestScoped
@Path("delivery")
public class DeliveryResource {

    @Inject
    private DeliveryDao deliverDao;

    // liefert alle delivery-eintraege zurueck
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response getDelivery() {
        List<Delivery> all = deliverDao.readAll();
        return Response.ok(all).build();
    }

    // erzeugt eine vorgegeben delivery und speichert diese in db
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    @Path("gen")
    public Response addDefault() {
        Delivery d = new Delivery("hrirks", 123, DeliveryStatus.ORDERED, PaymentStatus.PAID_WITH_CARD);
        deliverDao.create(d);
        return Response.ok().build();
    }

    // gibt delivery mit delivery.id == id zurueck
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    @Path("{id}")
    public Response getDeliverySituation(@PathParam("id") int id) {
        return Response.ok().entity(deliverDao.findByOrderIdList(id)).build();
    }

    // updated delivery mit delivery.id == id. deliveryStatus = dStatus wird gesetzt
    @PUT
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Transactional
    @Path("update/{id}")
    public Response update(@PathParam("id") int id, Delivery dStatus) {
        // Delivery d = deliverDao.read(id);
        Delivery d = deliverDao.findByOrderId(id);
        d.setStatus(DeliveryStatus.valueOf(dStatus.getStatus()));
        deliverDao.update(d);
        return Response.ok(d).build();

    }

    // fuege delivery in db hinzu und gebe als json zurueck
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Transactional
    @Path("add")
    public Response addDelivery(Delivery delivery) {
        deliverDao.create(delivery);
        // System.out.println("addDelivery");
        return Response.ok(delivery).build();
    }

    //
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    @Path("process/{id}")
    public Response startProcessing(@PathParam("id") int id) {
        System.out.println("Processing " + id);
        LogFileProcessor logProcessor = LogFileProcessor.getInstance();
        // ThreadPoolExecutor executor = system.getExecutor();
        Delivery d = deliverDao.findByOrderId(id);
        // deliverDao.update(d);
        // d.setStatus(DeliveryStatus.PREPARING);
        DeliverySystem deliverySystem = DeliverySystem.getInstance();
        // executor.submit(() -> {
        try {
            updateProcessor(logProcessor, d);
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }

        System.out.println("Finished!");
        Response.ok("Finished");
        return Response.ok("Processing Started ...").build();
    }

    // log und delivery update
    private void updateProcessor(LogFileProcessor logProcessor, Delivery d) throws IOException {
        DeliveryStatus[] status = DeliveryStatus.values();
        for (int i = 0; i < status.length; i++) {

            d.setStatus(status[i]);
            // deliverDao.update(d);
            httpUpdate(d.getOrderId(), status[i].toString());
            logProcessor.executeService(logProcessor.createFileLog(d));
            // System.out.println(d);
            try {
                // 10 Secs warten
                Thread.sleep(10000);
            } catch (InterruptedException e) {
                System.out.println(e.getMessage());
            }
        }
    }

    // aktulisiert aktuelle Delivery mit eingegebene Status
    private void httpUpdate(int id, String status) {
        HttpURLConnection con;
        try {
            URL url = new URL("http://localhost:9080/pizza-to-go-server/app/delivery/update/" + id);
            con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("PUT");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);
            OutputStreamWriter out = new OutputStreamWriter(con.getOutputStream());
            String jsonMsg = Json.createObjectBuilder().add("status", status).build().toString();
            System.out.println("Sending: " + jsonMsg);
            out.write(jsonMsg);
            out.close();
            con.getInputStream();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }

    //
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    @Path("log")
    public Response getLog() {
        String log = null;
        try {
            log = LogFileProcessor.getInstance().getLogData(Delivery.class.getName().toUpperCase());
            System.out.println(log);
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
        return Response.ok(log).build();
    }
}

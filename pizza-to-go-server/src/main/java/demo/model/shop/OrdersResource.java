package demo.model.shop;

import demo.model.ref.DeliveryStatus;
import demo.model.ref.PaymentStatus;
import demo.model.ref.Status;
import demo.model.shop.dataobjects.DeliveryDao;
import demo.model.shop.dataobjects.OrdersDao;
import demo.model.shop.entities.Delivery;
import demo.model.shop.entities.Orders;
import demo.model.shop.entities.Pizza;
import demo.model.shop.entities.Supplement;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import java.util.ArrayList;
import java.util.List;

@RequestScoped
@Path("orders")
public class OrdersResource {
    @Inject
    private OrdersDao ordersDao;

    @Inject
    private DeliveryDao deliverDao;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response getOrders() {
        List<Orders> ordersList = ordersDao.readAll();
        String json = Orders.ordersListToJsonString(ordersList);

        return Response.ok().entity(json).build();
    }

    //erzeugt eine vorgegeben delivery und speichert diese in db
    @POST
    @Path("delivery")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response deliver() {
        Delivery d = new Delivery("ujwal", 651, DeliveryStatus.ORDERED, PaymentStatus.CASH_ON_DELIVERY);
        deliverDao.create(d);

        return Response.ok().entity("Success!").build();
    }

    // gibt order mit order.id = pizzaId als json zurueck
    @GET
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response getOrderById(@PathParam("id") int orderId) {
        Orders order = ordersDao.read(orderId);
        String jsonString = order.toFormattedJsonString();

        return Response.ok().entity(jsonString).build();
    }

    // gibt order mit order.name = name als json zurueck
    @GET
    @Path("{username}")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response getSOrderByName(@PathParam("username") String username) {
        List<Orders> orders = new ArrayList<>();
        try {
             orders.addAll(ordersDao.findByUsername(username));
             System.out.println(ordersDao.findByUsername(username));

        } catch (IllegalStateException e) {
            System.out.println(e.getMessage());
        }
        return Response.ok().entity(orders).build();
    }

    // liest Order als JSON ein und fuegt sie der DB hinzu. JSON wird zurueckgegeben
    @POST
    @Path("addJson")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Transactional
    public Response addOrder(Orders order) {

        System.out.println(order.toFormattedJsonString());
        ordersDao.create(order);
        return Response.ok().entity(order.toFormattedJsonString() + " Created!").build();
    }

    //test-methode um erreichbarkeit ueber postman und rueckgabe als json zu testen
    @GET
    @Path("order")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response order() {
        Orders ord1 = new Orders("testuser","15.5","Amerika Str 1");

        // Pizza p1 = new Pizza("p1", 1, 12.05);
        // Pizza p2 = new Pizza("p2", 1, 12.15);

        Pizza p3 = new Pizza("Margheritta",2.2,"none" , "some pizza", 1);
        Pizza p2 = new Pizza("Salami",2.3,"none" , "some pizza", 2);

        // Supplement s1 = new Supplement("Tomaten");
        // Supplement s2 = new Supplement("Gurken");
        Supplement s3 = new Supplement("Gurken","path",0.80);
        Supplement s2 = new Supplement("Tomaten","path",0.80);

        p3.addSupplement(s3);
        p2.addSupplement(s2);
        p2.addSupplement(s3);

        ord1.addPizza(p2);
        ord1.addPizza(p3);

        // EntityManager em = ordersDao.getEm();
        // em.persist(ord1);
        ordersDao.create(ord1);

        return Response.ok(ord1.toFormattedJsonString()).build();
    }
}
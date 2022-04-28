package demo.model.shop.entities;

import java.util.Iterator;
import java.util.List;

import javax.json.Json;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import demo.model.ref.DeliveryStatus;
import demo.model.ref.DatabaseEntity;
import demo.model.ref.PaymentStatus;
import demo.model.ref.Logable;
/* 
* Delivery Entity mit 
*/
@Entity
@Table(name = "Delivery")
@NamedQuery(name = "Delivery.findAll", query = "SELECT d FROM Delivery d ")
@NamedQuery(name = "Delivery.findByName", query = "SELECT d FROM Delivery d WHERE d.username = :username")
@NamedQuery(name = "Delivery.findByOrderId", query = "SELECT d FROM Delivery d WHERE d.orderId = :orderId")
public class Delivery implements Logable, DatabaseEntity{

	@GeneratedValue(strategy = GenerationType.AUTO)
    @Id
	@Column(name = "dId")
    private int id;
    
    @Column(name = "Name")
    private String username;

    @Column(name = "orderId",unique = true)
    private int orderId;
  
    @Column(name = "status")
    private String status;

    @Column(name = "paymentStatus")
    private String paymentStatus;


    public Delivery(String username, int orderId, DeliveryStatus ordered, PaymentStatus cashOnDelivery) {
        this.username = username;
        this.orderId = orderId;
        this.status = ordered.toString();
        this.paymentStatus = cashOnDelivery.toString();
    }

    public Delivery() {
    }



	@Override
    public String toString() {
        return "{" +
            " id='" + getId() + "'" +
            ", username='" + getUsername() + "'" +
            ", orderId='" + getOrderId() + "'" +
            ", status='" + getStatus() + "'" +
            ", paymentStatus='" + getPaymentStatus() + "'" +
            "}";
    }


    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return this.username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getOrderId() {
        return this.orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getStatus() {
        return this.status;
    }

    public void setStatus(DeliveryStatus status) {
        this.status = status.toString();
    }

    public String getPaymentStatus() {
        return this.paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus.toString();
    }

    	//creates Json String fuer Supp. Ignoriert Attribut List<Pizza>
	public String toJsonString() {
		return Json.createObjectBuilder()
				.add("id", this.getId())
				.add("username", this.getUsername())
				.add("orderId", this.getOrderId())
				.add("deliveryStatus", this.getStatus())
				.add("paymentStatus", this.getPaymentStatus())
				.build()
				.toString();		
	}
	
	//gibt einen string im json format aus und nimmt als argument list von Delivery
	public static String suppListToJsonString(List<Delivery> list) {
		String result = "[";
		
		Iterator<Delivery> it = list.iterator();
		
		while(it.hasNext()) {
			Delivery supp = it.next();
			
			if(it.hasNext()) {//solange nicht letztes element erreicht, fueghe komma hinzu
				result += supp.toJsonString() + ",";
			}else {
				result += supp.toJsonString();
			}
			
		}
		
		result += "]";
		
		return result;
	}

}

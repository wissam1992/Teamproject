package demo.model.shop.log;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import demo.model.ref.DatabaseEntity;
import demo.model.ref.Status;

public class DeliverySystem {
    private int orderId;

    private Status status;

    private static DeliverySystem instance = null;

    //Thread Pool
    ExecutorService executorService = new ThreadPoolExecutor(1, 1, 0L, TimeUnit.MILLISECONDS, new LinkedBlockingQueue<Runnable>());

   private DeliverySystem(){}

   public static synchronized DeliverySystem getInstance(){
        if(instance == null){
            instance = new DeliverySystem();
        }
        return instance;
   }

   public void executeService(Runnable runnable){
    this.executorService.submit(runnable);
}

    public int getOrderId() {
        return this.orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Status getStatus() {
        return this.status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }
    
}

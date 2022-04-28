package demo.model.ref;

public enum DeliveryStatus implements Status{
    ORDERED, PREPARING,FINISHED ,ON_THE_WAY, DELIVERED;

    @Override
    public Enum getStatus() {
        return DeliveryStatus.DELIVERED;
    }
}
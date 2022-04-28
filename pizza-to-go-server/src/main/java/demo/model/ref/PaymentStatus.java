package demo.model.ref;

public enum PaymentStatus implements Status{
    CASH_ON_DELIVERY, PAID_WITH_CARD;

    @Override
    public Enum getStatus() {
        return PaymentStatus.CASH_ON_DELIVERY;
    }
}
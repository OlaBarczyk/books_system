package example.org.books_system;
import java.util.List;

public interface DeliveryService {
    List<Delivery> getDeliveries();
    void addDelivery(Delivery delivery);
    void updateDelivery(Delivery delivery);
    void deleteDelivery(Long id);
    Delivery getDeliveryById(Long deliveryId);
    Long getNextId();
}


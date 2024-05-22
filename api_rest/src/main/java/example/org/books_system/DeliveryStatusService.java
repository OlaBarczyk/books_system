package example.org.books_system;

import java.util.List;

public interface DeliveryStatusService {
    List<DeliveryStatus> getDeliveryStatuses();
    void addDeliveryStatus(DeliveryStatus deliveryStatus);
    void updateDeliveryStatus(DeliveryStatus deliveryStatus);
    void deleteDeliveryStatus(Long id);
    DeliveryStatus getDeliveryStatusById(Long deliveryStatusId);
    Long getNextId();
}

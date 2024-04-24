package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;

@Component
public class DeliveryStatusServiceImpl implements DeliveryStatusService {

    private final Logger log = LoggerFactory.getLogger(DeliveryStatusServiceImpl.class);
    private final List<DeliveryStatus> deliveryStatuses = new ArrayList<>();
    private Long nextId = 1L;

    @Override
    public List<DeliveryStatus> getDeliveryStatuses() {
        return deliveryStatuses;
    }

    @Override
    public void addDeliveryStatus(DeliveryStatus deliveryStatus) {
        if (deliveryStatus.getName() == null || deliveryStatus.getName().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Delivery_status name is required.");
        }

        deliveryStatus.setId(nextId++);
        deliveryStatuses.add(deliveryStatus);
        log.info("Author successfully added: {}", deliveryStatus);
    }

    @Override
    public void updateDeliveryStatus(DeliveryStatus deliveryStatus) {
        DeliveryStatus existingDeliveryStatus = findDeliveryStatusById(deliveryStatus.getId());
        if (existingDeliveryStatus == null) {
            log.error("Delivery_status with id {} has not been found", deliveryStatus.getId());
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Delivery_status with ID" + deliveryStatus.getId() + " has not been found for update");
        }

        // Check that all required fields are present
        if (deliveryStatus.getName() == null || deliveryStatus.getName().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Delivery_status name is required.");
        }


        existingDeliveryStatus.setName(deliveryStatus.getName());

        log.info("Delivery_status updated successfully: {}", deliveryStatus);
    }


    @Override
    public void deleteDeliveryStatus(Long id) {
        DeliveryStatus deliveryStatusToDelete = findDeliveryStatusById(id);
        if (deliveryStatusToDelete == null) {
            log.error("Delivery_status with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Delivery_status with ID " + id + " has not been found");
        }
        deliveryStatuses.remove(deliveryStatusToDelete);
        log.info("Delivery_status with id {} has been deleted", id);
    }

    private DeliveryStatus findDeliveryStatusById(Long id) {
        return deliveryStatuses.stream()
                .filter(deliveryStatus -> deliveryStatus.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public DeliveryStatus getDeliveryStatusById(Long deliveryStatusId) {
        return deliveryStatuses.stream()
                .filter(deliveryStatus -> deliveryStatus.getId().equals(deliveryStatusId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        return deliveryStatuses.stream()
                .map(DeliveryStatus::getId)
                .max(Long::compare)
                .orElse(0L) + 1;
    }
}

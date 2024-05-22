package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

@Service
public class DeliveryServiceImpl implements DeliveryService {
    private final Logger log = LoggerFactory.getLogger(DeliveryServiceImpl.class);
    private final List<Delivery> deliveries = new ArrayList<>();

    @Override
    public List<Delivery> getDeliveries() {
        return Collections.unmodifiableList(deliveries);
    }

    @Override
    public void addDelivery(Delivery delivery) {
        try {
            if (delivery.getId() == null) {
                delivery.setId(getNextId());
            }
            deliveries.add(delivery);
            log.info("Delivery has succesfully added: {}", delivery);
        } catch (Exception e) {
            log.error("A server error occurred while adding the delivery", e);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Server error occurred");
        }
    }

    @Override
    public void updateDelivery(Delivery delivery) {
        // Get old book (Book object)
        Delivery oldDelivery = deliveries.stream()
                .filter(e -> e.getId().equals(delivery.getId()))
                .findFirst()
                .orElse(null);

        if (oldDelivery == null) {
            log.error("Delivery with id {} has not been found", delivery.getId());
            throw new IllegalArgumentException("Delivery with ID " + delivery.getId() + " has not been found for update");
        }

        int index = deliveries.indexOf(oldDelivery);
        if (index != -1) {
            deliveries.set(index, delivery);
            log.info("Delivery has been succesfully updated: {}", delivery);
        } else {
            log.error("Delivery with id {} has not been found", delivery.getId());
        }
    }

    @Override
    public void deleteDelivery(Long id) {
        Optional<Delivery> deliveryToDelete = deliveries.stream()
                .filter(delivery -> delivery.getId().equals(id))
                .findFirst();

        if (deliveryToDelete.isPresent()) {
            deliveries.remove(deliveryToDelete.get());
            log.info("Delivery with id {} has been deleted", id);
        } else {
            log.error("Delivery with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Delivery with ID " + id + " has not been found");
        }
    }

    @Override
    public Delivery getDeliveryById(Long deliveryId) {
        return deliveries.stream()
                .filter(delivery -> delivery.getId().equals(deliveryId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        return deliveries.stream()
                .mapToLong(Delivery::getId)
                .max()
                .orElse(0L) + 1L;
    }

}

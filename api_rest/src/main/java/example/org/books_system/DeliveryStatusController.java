package example.org.books_system;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

// We add import for DefaultMessageSourceResolvable
import org.springframework.context.MessageSourceResolvable;
@RestController
@Slf4j
public class DeliveryStatusController {

    @Autowired
    private DeliveryStatusService deliveryStatusService;

    @GetMapping("/getDeliveryStatuses")
    public ResponseEntity<List<DeliveryStatus>> getDeliveryStatuses() {
        List<DeliveryStatus> deliveryStatuses = deliveryStatusService.getDeliveryStatuses();
        return new ResponseEntity<>(deliveryStatuses, HttpStatus.OK);
    }

    @PutMapping("/addDeliveryStatus")
    public ResponseEntity<String> addDeliveryStatus(@Valid @RequestBody DeliveryStatus deliveryStatus) {
        log.info("A request to add delivery status was received: {}", deliveryStatus);
        deliveryStatusService.addDeliveryStatus(deliveryStatus);
        log.info("Author successfully added: {}", deliveryStatus);
        return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
    }

    @PostMapping("/updateDeliveryStatus")
    public ResponseEntity<String> updateDeliveryStatus(@Valid @RequestBody DeliveryStatus deliveryStatus) {
        log.info("A request to update the delivery status has been received: {}", deliveryStatus);
        deliveryStatusService.updateDeliveryStatus(deliveryStatus);
        log.info("\n" +
                "Delivery status successfully updated: {}", deliveryStatus);
        return ResponseEntity.status(HttpStatus.OK).body("Updated!");
    }

    @DeleteMapping("/deleteDeliveryStatus/{id}")
    public ResponseEntity<String> deleteDeliveryStatus(@PathVariable Long id) {
        log.info("A request to delete the delivery status has been received with ID: {}", id);
        deliveryStatusService.deleteDeliveryStatus(id);
        log.info("Delivery status with ID {} deleted successfully", id);
        return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<String> handleValidationExceptions(MethodArgumentNotValidException ex) {
        String errorMessage = ex.getBindingResult().getAllErrors().stream()
                .map(MessageSourceResolvable::getDefaultMessage)
                .collect(Collectors.joining(", "));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: " + errorMessage);
    }
}

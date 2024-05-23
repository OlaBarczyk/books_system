package example.org.books_system;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import javax.validation.Valid;
import java.util.List;

@RestController
@Slf4j
public class DeliveryController {

    @Autowired
    private DeliveryService deliveryService;

    @GetMapping("/getDeliveries")
    public ResponseEntity<List<Delivery>> getDeliveries() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            List<Delivery> deliveries = deliveryService.getDeliveries();
            return new ResponseEntity<>(deliveries, HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addDelivery")
    public ResponseEntity<String> addDelivery(@Valid @RequestBody Delivery delivery) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            if (delivery.getDeliveryDate() == null || delivery.getUser() == null || delivery.getBook() == null || delivery.getDeliveryStatus() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: All fields are required.");
            }

            deliveryService.addDelivery(delivery);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updateDelivery")
    public ResponseEntity<String> updateDelivery(@Valid @RequestBody Delivery delivery) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            if (delivery.getId() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Delivery ID is required to update");
            }

            deliveryService.updateDelivery(delivery);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deleteDelivery/{id}")
    public ResponseEntity<String> deleteDelivery(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            deliveryService.deleteDelivery(id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    // Helper method to check user permissions
    private boolean hasAccess(String requiredRole) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals(requiredRole));
    }
}

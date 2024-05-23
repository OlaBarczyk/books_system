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
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @GetMapping("/getPayments")
    public ResponseEntity<List<Payment>> getPayments() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            List<Payment> payments = paymentService.getPayments();
            return new ResponseEntity<>(payments, HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addPayment")
    public ResponseEntity<String> addPayment(@Valid @RequestBody Payment payment) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to add a payment has been received: {}", payment.getPaymentDate());

            if (payment.getPaymentDate() == null || payment.getUser() == null || payment.getPaymentStatus() == null || payment.getAmount() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: All the fields are required.");
            }

            paymentService.addPayment(payment);
            log.info("Payment has added successfully: {}", payment);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updatePayment")
    public ResponseEntity<String> updatePayment(@Valid @RequestBody Payment payment) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to update the payment has been received: {}", payment.getPaymentDate());

            if (payment.getId() == null) {
                log.error("The payment requires an ID to be updated (ID)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Payment ID is required for update");
            }

            paymentService.updatePayment(payment);
            log.info("The payment has been successfully updated: {}", payment);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deletePayment/{id}")
    public ResponseEntity<String> deletePayment(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request has been received to remove the payment with id: {}", id);

            paymentService.deletePayment(id);
            log.info("Payment with id {} has successfully deleted", id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }
}

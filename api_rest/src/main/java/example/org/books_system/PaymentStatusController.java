package example.org.books_system;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSourceResolvable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@Slf4j
public class PaymentStatusController {

    @Autowired
    private PaymentStatusService paymentStatusService;

    @GetMapping("/getPaymentStatuses")
    public ResponseEntity<List<PaymentStatus>> getPaymentStatuses() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            List<PaymentStatus> paymentStatuses = paymentStatusService.getPaymentStatuses();
            return new ResponseEntity<>(paymentStatuses, HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addPaymentStatus")
    public ResponseEntity<String> addPaymentStatus(@Valid @RequestBody PaymentStatus paymentStatus) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to add payment status was received: {}", paymentStatus);
            paymentStatusService.addPaymentStatus(paymentStatus);
            log.info("Payment status successfully added: {}", paymentStatus);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updatePaymentStatus")
    public ResponseEntity<String> updatePaymentStatus(@Valid @RequestBody PaymentStatus paymentStatus) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to update the payment status has been received: {}", paymentStatus);
            paymentStatusService.updatePaymentStatus(paymentStatus);
            log.info("\n" +
                    "Payment status successfully updated: {}", paymentStatus);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deletePaymentStatus/{id}")
    public ResponseEntity<String> deletePaymentStatus(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to delete the payment status has been received with ID: {}", id);
            paymentStatusService.deletePaymentStatus(id);
            log.info("Payment status with ID {} deleted successfully", id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<String> handleValidationExceptions(MethodArgumentNotValidException ex) {
        String errorMessage = ex.getBindingResult().getAllErrors().stream()
                .map(MessageSourceResolvable::getDefaultMessage)
                .collect(Collectors.joining(", "));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: " + errorMessage);
    }
}

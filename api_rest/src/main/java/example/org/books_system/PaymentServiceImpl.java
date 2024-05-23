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
public class PaymentServiceImpl implements PaymentService {
    private final Logger log = LoggerFactory.getLogger(PaymentServiceImpl.class);
    private final List<Payment> payments = new ArrayList<>();

    @Override
    public List<Payment> getPayments() {
        return Collections.unmodifiableList(payments);
    }

    @Override
    public void addPayment(Payment payment) {
        try {
            if (payment.getId() == null) {
                payment.setId(getNextId());
            }
            payments.add(payment);
            log.info("Payment has succesfully added: {}", payment);
        } catch (Exception e) {
            log.error("A server error occurred while adding the payment", e);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Server error occurred");
        }
    }

    @Override
    public void updatePayment(Payment payment) {

        Payment oldPayment = payments.stream()
                .filter(e -> e.getId().equals(payment.getId()))
                .findFirst()
                .orElse(null);

        if (oldPayment == null) {
            log.error("Payment with id {} has not been found", payment.getId());
            throw new IllegalArgumentException("Payment with ID " + payment.getId() + " has not been found for update");
        }

        int index = payments.indexOf(oldPayment);
        if (index != -1) {
            payments.set(index, payment);
            log.info("Payment has been succesfully updated: {}", payment);
        } else {
            log.error("Payment with id {} has not been found", payment.getId());
        }
    }

    @Override
    public void deletePayment(Long id) {
        Optional<Payment> paymentToDelete = payments.stream()
                .filter(payment -> payment.getId().equals(id))
                .findFirst();

        if (paymentToDelete.isPresent()) {
            payments.remove(paymentToDelete.get());
            log.info("Payment with id {} has been deleted", id);
        } else {
            log.error("Payment with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Payment with ID " + id + " has not been found");
        }
    }

    @Override
    public Payment getPaymentById(Long paymentId) {
        return payments.stream()
                .filter(payment -> payment.getId().equals(paymentId))
                .findFirst()
                .orElse(null);
    }


    @Override
    public Long getNextId() {
        return payments.stream()
                .mapToLong(Payment::getId)
                .max()
                .orElse(0L) + 1L;
    }
}


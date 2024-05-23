package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import java.util.ArrayList;
import java.util.List;

@Component
public class PaymentStatusServiceImpl implements PaymentStatusService {

    private final Logger log = LoggerFactory.getLogger(PaymentStatusServiceImpl.class);
    private final List<PaymentStatus> paymentStatuses = new ArrayList<>();
    private Long nextId = 1L;

    @Override
    public List<PaymentStatus> getPaymentStatuses() {
        return paymentStatuses;
    }

    @Override
    public void addPaymentStatus(PaymentStatus paymentStatus) {
        if (paymentStatus.getStatus() == null || paymentStatus.getStatus().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Payment_status status is required.");
        }

        paymentStatus.setId(nextId++);
        paymentStatuses.add(paymentStatus);
        log.info("Payment status successfully added: {}", paymentStatus);
    }

    @Override
    public void updatePaymentStatus(PaymentStatus paymentStatus) {
        PaymentStatus existingPaymentStatus = findPaymentStatusById(paymentStatus.getId());
        if (existingPaymentStatus == null) {
            log.error("Payment_status with id {} has not been found", paymentStatus.getId());
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Payment_status with ID" + paymentStatus.getId() + " has not been found for update");
        }

        if (paymentStatus.getStatus() == null || paymentStatus.getStatus().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Payment_status status is required.");
        }

        existingPaymentStatus.setStatus(paymentStatus.getStatus());
        log.info("Payment_status updated successfully: {}", paymentStatus);
    }

    @Override
    public void deletePaymentStatus(Long id) {
        PaymentStatus paymentStatusToDelete = findPaymentStatusById(id);
        if (paymentStatusToDelete == null) {
            log.error("Payment_status with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Payment_status with ID " + id + " has not been found");
        }
        paymentStatuses.remove(paymentStatusToDelete);
        log.info("Payment_status with id {} has been deleted", id);
    }

    private PaymentStatus findPaymentStatusById(Long id) {
        return paymentStatuses.stream()
                .filter(paymentStatus -> paymentStatus.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public PaymentStatus getPaymentStatusById(Long paymentStatusId) {
        return paymentStatuses.stream()
                .filter(paymentStatus -> paymentStatus.getId().equals(paymentStatusId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        return paymentStatuses.stream()
                .map(PaymentStatus::getId)
                .max(Long::compare)
                .orElse(0L) + 1;
    }
}


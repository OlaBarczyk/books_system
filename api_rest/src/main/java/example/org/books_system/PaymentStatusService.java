package example.org.books_system;
import java.util.List;

public interface PaymentStatusService {

    List<PaymentStatus> getPaymentStatuses();
    void addPaymentStatus(PaymentStatus paymentStatus);
    void updatePaymentStatus(PaymentStatus paymentStatus);
    void deletePaymentStatus(Long id);
    PaymentStatus getPaymentStatusById(Long paymentStatusId);
    Long getNextId();
}


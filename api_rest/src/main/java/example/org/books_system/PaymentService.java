package example.org.books_system;
import java.util.List;

public interface PaymentService {

    List<Payment> getPayments();
    void addPayment(Payment payment);
    void updatePayment(Payment payment);
    void deletePayment(Long id);
    Payment getPaymentById(Long paymentId);
    Long getNextId();
}



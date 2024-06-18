package example.org.books_system;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentRepository extends JpaRepository<Payment,Long> {
    List<Payment> findAll();
    List<Payment> findByPaymentDate(LocalDate paymentDate);
    List<Payment> findByAmount(BigDecimal amount);
    List<Payment> findByUserId(Long userId);
    List<Payment> findByPaymentStatusId(Long paymentStatusId);
}

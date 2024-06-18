package example.org.books_system;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentStatusRepository extends JpaRepository<PaymentStatus,Long>{
    List<PaymentStatus> findByStatus(String status);
}

package example.org.books_system;

import java.time.LocalDate;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DeliveryRepository extends JpaRepository<Delivery, Long> {
    List<Delivery> findAll();
    List<Delivery> findByDeliveryDate(LocalDate deliveryDate);
    List<Delivery> findByUserId(Long userId);
    List<Delivery> findByBookId(Long bookId);
    List<Delivery> findByDeliveryStatusId(Long deliveryStatusId);
}

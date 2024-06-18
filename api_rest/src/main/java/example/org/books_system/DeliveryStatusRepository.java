package example.org.books_system;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DeliveryStatusRepository extends JpaRepository<DeliveryStatus,Long>{
    List<DeliveryStatus> findByName(String name);
}

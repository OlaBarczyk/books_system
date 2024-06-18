package example.org.books_system;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReservationStatusRepository extends JpaRepository<ReservationStatus,Long>{
    List<ReservationStatus> findByStatus(String status);
}
package example.org.books_system;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RentalStatusRepository extends JpaRepository<RentalStatus,Long>{
    List<RentalStatus> findByStatus(String status);
}

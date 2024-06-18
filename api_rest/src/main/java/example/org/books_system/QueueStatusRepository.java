package example.org.books_system;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QueueStatusRepository extends JpaRepository<QueueStatus,Long>{
    List<QueueStatus> findByStatus(String status);
}

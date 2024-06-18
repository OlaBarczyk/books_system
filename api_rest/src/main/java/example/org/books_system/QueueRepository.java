package example.org.books_system;

import org.springframework.data.jpa.repository.JpaRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface QueueRepository extends JpaRepository<Queue,Long> {
    List<Queue> findAll();
    List<Queue> findByUserId(Long userId);
    List<Queue> findByBookId(Long bookId);
    List<Queue> findByQueueStatusId(Long queueStatusId);
}

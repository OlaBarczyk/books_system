package example.org.books_system;

import java.time.LocalDate;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findAll();
    List<Notification> findBySendingDate(LocalDate sendingDate);
    List<Notification> findByMessage(String message);
    List<Notification> findByUserId(Long userId);
    List<Notification> findByNotificationTypeId(Long notificationTypeId);
}

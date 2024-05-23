package example.org.books_system;
import java.util.List;

public interface NotificationService {
    List<Notification> getNotifications();
    void addNotification(Notification notification);
    void updateNotification(Notification notification);
    void deleteNotification(Long id);
    Notification getNotificationById(Long notificationId);
    Long getNextId();
}



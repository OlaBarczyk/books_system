package example.org.books_system;

import java.util.List;

public interface NotificationTypeService {
    List<NotificationType> getNotificationTypes();
    void addNotificationType(NotificationType notificationType);
    void updateNotificationType(NotificationType notificationType);
    void deleteNotificationType(Long id);
    NotificationType getNotificationTypeById(Long notificationTypeId);
    Long getNextId();
}

package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import java.util.ArrayList;
import java.util.List;

@Component
public class NotificationTypeServiceImpl implements NotificationTypeService {

    private final Logger log = LoggerFactory.getLogger(NotificationTypeServiceImpl.class);
    private final List<NotificationType> notificationTypes = new ArrayList<>();
    private Long nextId = 1L;

    @Override
    public List<NotificationType> getNotificationTypes() {
        return notificationTypes;
    }

    @Override
    public void addNotificationType(NotificationType notificationType) {
        if (notificationType.getType() == null || notificationType.getType().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Notification_type type is required.");
        }
        notificationType.setId(nextId++);
        notificationTypes.add(notificationType);
        log.info("Notification type successfully added: {}", notificationType);
    }

    @Override
    public void updateNotificationType(NotificationType notificationType) {
        NotificationType existingNotificationType = findNotificationTypeById(notificationType.getId());
        if (existingNotificationType == null) {
            log.error("Notification_type with id {} has not been found", notificationType.getId());
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Notification_type with ID" + notificationType.getId() + " has not been found for update");
        }

        if (notificationType.getType() == null || notificationType.getType().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Notification_type type is required.");
        }

        existingNotificationType.setType(notificationType.getType());
        log.info("Notification_type updated successfully: {}", notificationType);
    }

    @Override
    public void deleteNotificationType(Long id) {
        NotificationType notificationTypeToDelete = findNotificationTypeById(id);
        if (notificationTypeToDelete == null) {
            log.error("Notification_type with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Notification_type with ID " + id + " has not been found");
        }
        notificationTypes.remove(notificationTypeToDelete);
        log.info("Notification_type with id {} has been deleted", id);
    }

    private NotificationType findNotificationTypeById(Long id) {
        return notificationTypes.stream()
                .filter(notificationType -> notificationType.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public NotificationType getNotificationTypeById(Long notificationTypeId) {
        return notificationTypes.stream()
                .filter(notificationType -> notificationType.getId().equals(notificationTypeId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        return notificationTypes.stream()
                .map(NotificationType::getId)
                .max(Long::compare)
                .orElse(0L) + 1;
    }
}

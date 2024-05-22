package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

@Service
public class NotificationServiceImpl implements NotificationService {
    private final Logger log = LoggerFactory.getLogger(NotificationServiceImpl.class);
    private final List<Notification> notifications = new ArrayList<>();

    @Override
    public List<Notification> getNotifications() {
        return Collections.unmodifiableList(notifications);
    }

    @Override
    public void addNotification(Notification notification) {
        try {
            if (notification.getId() == null) {
                notification.setId(getNextId());
            }
            notifications.add(notification);
            log.info("Notification has succesfully added: {}", notification);
        } catch (Exception e) {
            log.error("A server error occurred while adding the notification", e);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Server error occurred");
        }
    }

    @Override
    public void updateNotification(Notification notification) {

        Notification oldNotification = notifications.stream()
                .filter(e -> e.getId().equals(notification.getId()))
                .findFirst()
                .orElse(null);

        if (oldNotification == null) {
            // throw exception
            log.error("Notification with id {} has not been found", notification.getId());
            throw new IllegalArgumentException("Notification with ID " + notification.getId() + " has not been found for update");
        }

        int index = notifications.indexOf(oldNotification);
        if (index != -1) {
            notifications.set(index, notification);
            log.info("Notification has been succesfully updated: {}", notification);
        } else {
            log.error("Notification with id {} has not been found", notification.getId());
        }
    }

    @Override
    public void deleteNotification(Long id) {
        Optional<Notification> notificationToDelete = notifications.stream()
                .filter(notification -> notification.getId().equals(id))
                .findFirst();

        if (notificationToDelete.isPresent()) {
            notifications.remove(notificationToDelete.get());
            log.info("Notification with id {} has been deleted", id);
        } else {
            log.error("Notification with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Notification with ID " + id + " has not been found");
        }
    }

    @Override
    public Notification getNotificationById(Long notificationId) {
        return notifications.stream()
                .filter(notification -> notification.getId().equals(notificationId))
                .findFirst()
                .orElse(null);
    }


    @Override
    public Long getNextId() {
        return notifications.stream()
                .mapToLong(Notification::getId)
                .max()
                .orElse(0L) + 1L;
    }

}

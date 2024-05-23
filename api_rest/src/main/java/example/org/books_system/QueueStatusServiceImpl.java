package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import java.util.ArrayList;
import java.util.List;

@Component
public class QueueStatusServiceImpl implements QueueStatusService {

    private final Logger log = LoggerFactory.getLogger(QueueStatusServiceImpl.class);
    private final List<QueueStatus> queueStatuses = new ArrayList<>();
    private final List<Long> deletedIds = new ArrayList<>();
    private Long nextId = 1L;

    @Override
    public List<QueueStatus> getQueueStatuses() {
        return queueStatuses;
    }

    @Override
    public void addQueueStatus(QueueStatus queueStatus) {
        if (queueStatus.getStatus() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Status of queue status is required!.");
        }
        Long id = getNextId();
        queueStatus.setId(id);
        queueStatuses.add(queueStatus);
        log.info("Queue status has been added successfully: {}", queueStatus);
    }

    @Override
    public void updateQueueStatus(QueueStatus queueStatus) {
        if (queueStatus.getId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Queue status id is required.");
        }

        if (queueStatus.getStatus() == null || queueStatus.getStatus().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Queue status is required.");
        }

        QueueStatus existingQueueStatus = findQueueStatusById(queueStatus.getId());
        if (existingQueueStatus == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Queue status with ID " + queueStatus.getId() + " has not been found for update");
        }

        existingQueueStatus.setStatus(queueStatus.getStatus());
        log.info("Queue status has been updated successfully: {}", queueStatus);
    }

    private QueueStatus findQueueStatusById(Long id) {
        return queueStatuses.stream()
                .filter(queueStatus -> queueStatus.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public void deleteQueueStatus(Long id) {
        QueueStatus queueStatusToDelete = findQueueStatusById(id);
        if (queueStatusToDelete == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Queue status with ID " + id + " has not been found");
        }
        queueStatuses.remove(queueStatusToDelete);
        deletedIds.add(id);
        log.info("Queue status with id {} has been deleted", id);
    }

    @Override
    public QueueStatus getQueueStatusById(Long queueStatusId) {
        return queueStatuses.stream()
                .filter(queueStatus -> queueStatus.getId().equals(queueStatusId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        if (!deletedIds.isEmpty()) {
            Long id = deletedIds.remove(0);
            log.info("Reusing a deleted one ID: {}", id);
            return id;
        }
        return nextId++;
    }
}

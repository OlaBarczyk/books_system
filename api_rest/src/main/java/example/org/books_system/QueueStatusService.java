package example.org.books_system;

import java.util.List;

public interface QueueStatusService {
    List<QueueStatus> getQueueStatuses();
    void addQueueStatus(QueueStatus queueStatus);
    void updateQueueStatus(QueueStatus queueStatus);
    void deleteQueueStatus(Long id);
    QueueStatus getQueueStatusById(Long queueStatusId);
    Long getNextId();
}


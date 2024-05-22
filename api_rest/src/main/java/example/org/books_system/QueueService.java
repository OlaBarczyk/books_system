package example.org.books_system;
import java.util.List;

public interface QueueService {

    List<Queue> getQueues();
    void addQueue(Queue queue);
    void updateQueue(Queue queue);
    void deleteQueue(Long id);
    Queue getQueueById(Long queueId);
    Long getNextId();
}




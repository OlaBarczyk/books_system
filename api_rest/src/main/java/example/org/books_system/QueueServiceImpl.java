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
public class QueueServiceImpl implements QueueService {
    private final Logger log = LoggerFactory.getLogger(QueueServiceImpl.class);
    private final List<Queue> queues = new ArrayList<>();

    @Override
    public List<Queue> getQueues() {
        return Collections.unmodifiableList(queues);
    }

    @Override
    public void addQueue(Queue queue) {
        try {
            if (queue.getId() == null) {
                queue.setId(getNextId());
            }
            queues.add(queue);
            log.info("Queue has succesfully added: {}", queue);
        } catch (Exception e) {
            log.error("A server error occurred while adding the queue", e);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Server error occurred");
        }
    }

    @Override
    public void updateQueue(Queue queue) {

        Queue oldQueue = queues.stream()
                .filter(e -> e.getId().equals(queue.getId()))
                .findFirst()
                .orElse(null);

        if (oldQueue == null) {
            // throw exception
            log.error("Queue with id {} has not been found", queue.getId());
            throw new IllegalArgumentException("Queue with ID " + queue.getId() + " has not been found for update");
        }

        int index = queues.indexOf(oldQueue);
        if (index != -1) {
            queues.set(index, queue);
            log.info("Queue has been succesfully updated: {}", queue);
        } else {
            log.error("Queue with id {} has not been found", queue.getId());
        }
    }

    @Override
    public void deleteQueue(Long id) {
        Optional<Queue> queueToDelete = queues.stream()
                .filter(queue -> queue.getId().equals(id))
                .findFirst();

        if (queueToDelete.isPresent()) {
            queues.remove(queueToDelete.get());
            log.info("Queue with id {} has been deleted", id);
        } else {
            log.error("Queue with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Queue with ID " + id + " has not been found");
        }
    }

    @Override
    public Queue getQueueById(Long queueId) {
        return queues.stream()
                .filter(queue -> queue.getId().equals(queueId))
                .findFirst()
                .orElse(null);
    }


    @Override
    public Long getNextId() {
        return queues.stream()
                .mapToLong(Queue::getId)
                .max()
                .orElse(0L) + 1L;
    }

}



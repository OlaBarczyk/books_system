package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;

@Component
public class PublisherServiceImpl implements PublisherService {

    private final Logger log = LoggerFactory.getLogger(PublisherServiceImpl.class);
    private final List<Publisher> publishers = new ArrayList<>();
    private final List<Long> deletedIds = new ArrayList<>();
    private Long nextId = 1L;

    @Override
    public List<Publisher> getPublishers() {
        return publishers;
    }

    @Override
    public void addPublisher(Publisher publisher) {
        if (publisher.getName() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Name of publisher is required!.");
        }

        Long id = getNextId();
        publisher.setId(id);
        publishers.add(publisher);
        log.info("Pusblisher has been added successfully: {}", publisher);
    }

    @Override
    public void updatePublisher(Publisher publisher) {
        if (publisher.getId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Publisher id is required.");
        }

        Publisher existingPublisher = findPublisherById(publisher.getId());
        if (existingPublisher == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Publisher with ID " + publisher.getId() + " has not been found for update");
        }
        existingPublisher.setName(publisher.getName());
        log.info("Publisher has been updated successfully: {}", publisher);
    }

    private Publisher findPublisherById(Long id) {
        return publishers.stream()
                .filter(publisher -> publisher.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public void deletePublisher(Long id) {
        Publisher publisherToDelete = findPublisherById(id);
        if (publisherToDelete == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Publisher with ID " + id + " has not been found");
        }
        publishers.remove(publisherToDelete);
        deletedIds.add(id);
        log.info("Publisher with id {} has been deleted", id);
    }

    @Override
    public Publisher getPublisherById(Long publisherId) {
        return publishers.stream()
                .filter(publisher -> publisher.getId().equals(publisherId))
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

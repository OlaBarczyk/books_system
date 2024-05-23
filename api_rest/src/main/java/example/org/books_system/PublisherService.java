package example.org.books_system;

import java.util.List;

public interface PublisherService {
    List<Publisher> getPublishers();
    void addPublisher(Publisher publisher);
    void updatePublisher(Publisher publisher);
    void deletePublisher(Long id);
    Publisher getPublisherById(Long publisherId);
    Long getNextId();
}




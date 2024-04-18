package example.org.books_system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

public interface PublisherService {
    List<Publisher> getPublishers();
    void addPublisher(Publisher publisher);
    void updatePublisher(Publisher publisher);
    void deletePublisher(Long id);

    Publisher getPublisherById(Long publisherId);

    Long getNextId();
}




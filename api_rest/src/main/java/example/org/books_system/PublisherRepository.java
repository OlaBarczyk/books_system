package example.org.books_system;


import java.util.List;
import example.org.books_system.Publisher;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PublisherRepository extends JpaRepository<Publisher,Long>{
    List<Publisher> findByName(String name);
}


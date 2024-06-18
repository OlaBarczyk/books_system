package example.org.books_system;
import java.util.List;
import example.org.books_system.Author;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AuthorRepository extends JpaRepository<Author, Long> {
    List<Author> findByFirstName(String firstName);
}

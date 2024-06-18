package example.org.books_system;

import java.util.List;
import example.org.books_system.Genre;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GenreRepository extends JpaRepository<Genre,Long>{
    List<Genre> findByName(String name);
}

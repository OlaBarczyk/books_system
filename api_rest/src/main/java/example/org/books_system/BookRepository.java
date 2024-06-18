package example.org.books_system;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookRepository extends JpaRepository<Book, Long> {
    List<Book> findAll();
    List<Book> findByTitle(String title);
    List<Book> findByISBN(Long isbn);
    List<Book> findByNumberOfPages(Integer numberOfPages);
    List<Book> findByAuthorId(Long authorId);
    List<Book> findByPublisherId(Long publisherId);
    List<Book> findByGenreId(Long genreId);
}

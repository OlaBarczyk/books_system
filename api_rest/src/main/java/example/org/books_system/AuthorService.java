package example.org.books_system;

import java.util.List;

public interface AuthorService {
    List<Author> getAuthors();
    void addAuthor(Author author);
    void updateAuthor(Author author);
    void deleteAuthor(Long id);
    Author getAuthorById(Long authorId);
    Long getNextId();
}


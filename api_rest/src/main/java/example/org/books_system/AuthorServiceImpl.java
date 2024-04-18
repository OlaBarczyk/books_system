package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;

@Component
public class AuthorServiceImpl implements AuthorService {

    private final Logger log = LoggerFactory.getLogger(AuthorServiceImpl.class);
    private final List<Author> authors = new ArrayList<>();
    private Long nextId = 1L;

    @Override
    public List<Author> getAuthors() {
        return authors;
    }

    @Override
    public void addAuthor(Author author) {
        if (author.getFirstName() == null || author.getFirstName().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Author's name is required.");
        }
        if (author.getLastName() == null || author.getLastName().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Author's last name is required.");
        }
        author.setId(nextId++);
        authors.add(author);
        log.info("Author successfully added: {}", author);
    }

    @Override
    public void updateAuthor(Author author) {
        Author existingAuthor = findAuthorById(author.getId());
        if (existingAuthor == null) {
            log.error("Author with id {} has not been found", author.getId());
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Author with ID" + author.getId() + " has not been found for update");
        }

        // Check that all required fields are present
        if (author.getFirstName() == null || author.getFirstName().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Author's name is required.");
        }
        if (author.getLastName() == null || author.getLastName().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Author's lastname is required.");
        }

        existingAuthor.setFirstName(author.getFirstName());
        existingAuthor.setLastName(author.getLastName());
        log.info("Author updated successfully: {}", author);
    }


    @Override
    public void deleteAuthor(Long id) {
        Author authorToDelete = findAuthorById(id);
        if (authorToDelete == null) {
            log.error("Author with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Author with ID " + id + " has not been found");
        }
        authors.remove(authorToDelete);
        log.info("Author with id {} has been deleted", id);
    }

    private Author findAuthorById(Long id) {
        return authors.stream()
                .filter(author -> author.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Author getAuthorById(Long authorId) {
        return authors.stream()
                .filter(author -> author.getId().equals(authorId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        return authors.stream()
                .map(Author::getId)
                .max(Long::compare)
                .orElse(0L) + 1;
    }
}

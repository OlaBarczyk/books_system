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
public class BookServiceImpl implements BookService {
    private final Logger log = LoggerFactory.getLogger(BookServiceImpl.class);
    private final List<Book> books = new ArrayList<>();

    @Override
    public List<Book> getBooks() {
        return Collections.unmodifiableList(books);
    }

    @Override
    public void addBook(Book book) {
        try {
            if (book.getId() == null) {
                book.setId(getNextId());
            }
            books.add(book);
            log.info("Book has succesfully added: {}", book);
        } catch (Exception e) {
            log.error("A server error occurred while adding the book", e);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Server error occurred");
        }
    }

    @Override
    public void updateBook(Book book) {
        // Get old book (Book object)
        Book oldBook = books.stream()
                .filter(e -> e.getId().equals(book.getId()))
                .findFirst()
                .orElse(null);

        if (oldBook == null) {
            // throw exception
            log.error("Book with id {} has not been found", book.getId());
            throw new IllegalArgumentException("Book with ID " + book.getId() + " has not been found for update");
        }

        int index = books.indexOf(oldBook);
        if (index != -1) {
            books.set(index, book);
            log.info("Book has been succesfully updated: {}", book);
        } else {
            log.error("Book with id {} has not been found", book.getId());
        }
    }

    @Override
    public void deleteBook(Long id) {
        Optional<Book> bookToDelete = books.stream()
                .filter(book -> book.getId().equals(id))
                .findFirst();

        if (bookToDelete.isPresent()) {
            books.remove(bookToDelete.get());
            log.info("Book with id {} has been deleted", id);
        } else {
            log.error("Book with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Book with ID " + id + " has not been found");
        }
    }

    @Override
    public Book getBookById(Long bookId) {
        return books.stream()
                .filter(book -> book.getId().equals(bookId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        return books.stream()
                .mapToLong(Book::getId)
                .max()
                .orElse(0L) + 1L;
    }

}

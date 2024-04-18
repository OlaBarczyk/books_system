package example.org.books_system;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@RestController
@Slf4j
public class BookController {

    @Autowired
    private BookService bookService;

    @GetMapping("/getBooks")
    public ResponseEntity<List<Book>> getBooks() {
        List<Book> books = bookService.getBooks();
        return new ResponseEntity<>(books, HttpStatus.OK);
    }

    @PutMapping("/addBook")
    public ResponseEntity<String> addBook(@Valid @RequestBody Book book) {
        log.info("A request to add a book has been received: {}", book.getTitle());

        // Check that all required fields are present
        if (book.getTitle() == null || book.getAuthor() == null || book.getPublisher() == null || book.getGenre() == null || book.getISBN() == 0 || book.getNumber_of_pages() == 0) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: All the fields are required.");
        }

        bookService.addBook(book);
        log.info("Book has added successfully: {}", book);
        return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
    }


    @PostMapping("/updateBook")
    public ResponseEntity<String> updateBook(@Valid @RequestBody Book book) {
        log.info("A request to update the book has been received: {}", book.getTitle());

        // Check for null ID before calling updateBook
        if (book.getId() == null) {
            log.error("The book requires an ID to be updated (ID)");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Book ID is required for update");
        }

        bookService.updateBook(book);
        log.info("The book has been successfully updated: {}", book);
        return ResponseEntity.status(HttpStatus.OK).body("Updated!");
    }

    @DeleteMapping("/deleteBook/{id}")
    public ResponseEntity<String> deleteBook(@PathVariable Long id) {
        log.info("A request has been received to remove the book with id: {}", id);

        bookService.deleteBook(id);
        log.info("Book with id {} has successfully deleted", id);
        return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
    }
}

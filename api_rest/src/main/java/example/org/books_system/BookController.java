package example.org.books_system;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import javax.validation.Valid;
import java.util.List;

@RestController
@Slf4j
public class BookController {

    @Autowired
    private BookService bookService;

    @GetMapping("/getBooks")
    public ResponseEntity<List<Book>> getBooks() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            List<Book> books = bookService.getBooks();
            System.out.println("List of books:" + books.size());
            for(Book book: books) {
                System.out.println(book.getTitle());
            }
            return new ResponseEntity<>(books, HttpStatus.OK);
        } else {
            System.out.println("Error by getting books");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addBook")
    public ResponseEntity<String> addBook(@Valid @RequestBody Book book) {
        log.info("Received request to add book: {}", book.getTitle());


        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            if (book.getTitle() == null || book.getAuthor() == null || book.getPublisher() == null || book.getGenre() == null || book.getISBN() == 0 || book.getNumberOfPages() == 0) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: All fields are required.");
            }

            bookService.addBook(book);
            log.info("Book was successfully added: {}", book);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updateBook")
    public ResponseEntity<String> updateBook(@Valid @RequestBody Book book) {
        log.info("Received request to update book: {}", book.getTitle());


        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            if (book.getId() == null) {
                log.error("Book requires ID to update (ID)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Book ID is required to update");
            }
            bookService.updateBook(book);
            log.info("Book was successfully updated: {}", book);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deleteBook/{id}")
    public ResponseEntity<String> deleteBook(@PathVariable Long id) {
        log.info("Received request to delete book with id: {}", id);
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            bookService.deleteBook(id);
            log.info("Book with id {} was successfully deleted", id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    // Helper method to check user permissions
    private boolean hasAccess(String requiredRole) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals(requiredRole));
    }
}

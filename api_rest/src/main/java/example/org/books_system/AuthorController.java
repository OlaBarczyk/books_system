package example.org.books_system;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import javax.validation.Valid;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

// We add import for DefaultMessageSourceResolvable
import org.springframework.context.MessageSourceResolvable;

@RestController
@Slf4j
public class AuthorController {

    @Autowired
    private AuthorService authorService;

    @GetMapping("/getAuthors")
    public ResponseEntity<List<Author>> getAuthors() {
        List<Author> authors = authorService.getAuthors();
        return new ResponseEntity<>(authors, HttpStatus.OK);
    }

    @PutMapping("/addAuthor")
    public ResponseEntity<String> addAuthor(@Valid @RequestBody Author author) {
        log.info("A request to add an author has been received: {}", author);
        authorService.addAuthor(author);
        log.info("Author successfully added: {}", author);
        return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
    }

    @PostMapping("/updateAuthor")
    public ResponseEntity<String> updateAuthor(@Valid @RequestBody Author author) {
        log.info("\n" +
                "Author update request received: {}", author);
        authorService.updateAuthor(author);
        log.info("Author updated successfully: {}", author);
        return ResponseEntity.status(HttpStatus.OK).body("Updated!");
    }

    @DeleteMapping("/deleteAuthor/{id}")
    public ResponseEntity<String> deleteAuthor(@PathVariable Long id) {
        log.info("A request to remove author with this ID has been received: {}", id);
        authorService.deleteAuthor(id);
        log.info("Author with id {} deleted successfully", id);
        return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<String> handleValidationExceptions(MethodArgumentNotValidException ex) {
        String errorMessage = ex.getBindingResult().getAllErrors().stream()
                .map(MessageSourceResolvable::getDefaultMessage)
                .collect(Collectors.joining(", "));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: " + errorMessage);
    }
}

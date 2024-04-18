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


import org.springframework.context.MessageSourceResolvable;

@RestController
@Slf4j
public class PublisherController {

    @Autowired
    private PublisherService publisherService;

    @GetMapping("/getPublishers")
    public ResponseEntity<List<Publisher>> getPublishers() {
        List<Publisher> publishers = publisherService.getPublishers();
        return new ResponseEntity<>(publishers, HttpStatus.OK);
    }

    @PutMapping("/addPublisher")
    public ResponseEntity<String> addPublisher(@Valid @RequestBody Publisher publisher) {
        log.info("A request to add a publishing house has been received: {}", publisher);
        publisherService.addPublisher(publisher);
        log.info("Publisher successfully added: {}", publisher);
        return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
    }

    @PostMapping("/updatePublisher")
    public ResponseEntity<String> updatePublisher(@Valid @RequestBody Publisher publisher) {
        log.info("\n" +
                "A request for a publishing update has been received: {}", publisher);
        publisherService.updatePublisher(publisher);
        log.info("Publisher has been updated successfully: {}", publisher);
        return ResponseEntity.status(HttpStatus.OK).body("Updated!");
    }

    @DeleteMapping("/deletePublisher/{id}")
    public ResponseEntity<String> deletePublisher(@PathVariable Long id) {
        log.info("A request to remove the publication has been received with id: {}", id);
        publisherService.deletePublisher(id);
        log.info("Publisher with id {} has been deleted successfully", id);
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
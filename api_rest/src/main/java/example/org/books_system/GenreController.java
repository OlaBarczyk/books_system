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
public class GenreController {

    @Autowired
    private GenreService genreService;

    @GetMapping("/getGenres")
    public ResponseEntity<List<Genre>> getGenres() {
        List<Genre> genres = genreService.getGenres();
        return new ResponseEntity<>(genres, HttpStatus.OK);
    }

    @PutMapping("/addGenre")
    public ResponseEntity<String> addGenre(@Valid @RequestBody Genre genre) {
        log.info("A request to add a species has been received: {}", genre);
        genreService.addGenre(genre);
        log.info("Species successfully added: {}", genre);
        return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
    }

    @PostMapping("/updateGenre")
    public ResponseEntity<String> updateGenre(@Valid @RequestBody Genre genre) {
        log.info("A species update request has been received: {}", genre);
        genreService.updateGenre(genre);
        log.info("Species successfully updated: {}", genre);
        return ResponseEntity.status(HttpStatus.OK).body("Updated!");
    }

    @DeleteMapping("/deleteGenre/{id}")
    public ResponseEntity<String> deleteGenre(@PathVariable Long id) {
        log.info("A request has been received to remove the species with id: {}", id);
        genreService.deleteGenre(id);
        log.info("Genre with ID {} has been deleted successfully", id);
        return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<String> handleValidationExceptions(MethodArgumentNotValidException ex) {
        String errorMessage = ex.getBindingResult().getAllErrors().stream()
                .map(MessageSourceResolvable::getDefaultMessage) // Poprawiony import
                .collect(Collectors.joining(", "));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: " + errorMessage);
    }
}

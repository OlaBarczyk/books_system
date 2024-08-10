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
public class GenreController {

    @Autowired
    private GenreService genreService;

    @GetMapping("/getGenres")
    public ResponseEntity<List<Genre>> getGenres() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER") || authority.getAuthority().equals("ROLE_ADMIN"))) {
            List<Genre> genres = genreService.getGenres();
            return new ResponseEntity<>(genres, HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addGenre")
    public ResponseEntity<String> addGenre(@Valid @RequestBody Genre genre) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            genreService.addGenre(genre);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updateGenre")
    public ResponseEntity<String> updateGenre(@Valid @RequestBody Genre genre) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            genreService.updateGenre(genre);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deleteGenre/{id}")
    public ResponseEntity<String> deleteGenre(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            genreService.deleteGenre(id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    // WIP: - Helper method to check user permissions
    private boolean hasAccess(String requiredRole) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals(requiredRole));
    }
}

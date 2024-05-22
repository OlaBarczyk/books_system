package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import java.util.ArrayList;
import java.util.List;

@Component
public class GenreServiceImpl implements GenreService {

    private final Logger log = LoggerFactory.getLogger(GenreServiceImpl.class);
    private final List<Genre> genres = new ArrayList<>();
    private final List<Long> deletedIds = new ArrayList<>();
    private Long nextId = 1L;

    @Override
    public List<Genre> getGenres() {
        return genres;
    }

    @Override
    public void addGenre(Genre genre) {
        if (genre.getName() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Name of genre is required.");
        }
        Long id = getNextId();
        genre.setId(id);
        genres.add(genre);
        log.info("Genre has been added succesfully: {}", genre);
    }

    @Override
    public void updateGenre(Genre genre) {
        if (genre.getId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Genre ID is required.");
        }
        Genre existingGenre = findGenreById(genre.getId());
        if (existingGenre == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Genre with ID " + genre.getId() + " has not been found for update");
        }
        existingGenre.setName(genre.getName());
        log.info("Genre has been succesfully updated: {}", genre);
    }

    @Override
    public void deleteGenre(Long id) {
        Genre genreToDelete = findGenreById(id);
        if (genreToDelete == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Genre with ID " + id + " has not been found");
        }
        genres.remove(genreToDelete);
        deletedIds.add(id);
        log.info("Genre with id {} has been deleted", id);
    }

    private Genre findGenreById(Long id) {
        return genres.stream()
                .filter(genre -> genre.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Genre getGenreById(Long genreId) {
        return genres.stream()
                .filter(genre -> genre.getId().equals(genreId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        if (!deletedIds.isEmpty()) {
            Long id = deletedIds.remove(0);
            log.info("Reusing a deleted ID: {}", id);
            return id;
        }
        return nextId++;
    }
}


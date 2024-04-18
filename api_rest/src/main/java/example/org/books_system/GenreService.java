package example.org.books_system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

public interface GenreService {
    List<Genre> getGenres();
    void addGenre(Genre genre);
    void updateGenre(Genre genre);
    void deleteGenre(Long id);

    Genre getGenreById(Long publisherId);

    Long getNextId();
}


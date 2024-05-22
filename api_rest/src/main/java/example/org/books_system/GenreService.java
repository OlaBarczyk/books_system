package example.org.books_system;

import java.util.List;

public interface GenreService {
    List<Genre> getGenres();
    void addGenre(Genre genre);
    void updateGenre(Genre genre);
    void deleteGenre(Long id);
    Genre getGenreById(Long publisherId);
    Long getNextId();
}


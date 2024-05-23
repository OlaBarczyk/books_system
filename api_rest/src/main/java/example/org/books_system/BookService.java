package example.org.books_system;

import java.util.List;

public interface BookService {
    List<Book> getBooks();
    void addBook(Book book);
    void updateBook(Book book);
    void deleteBook(Long id);
    Book getBookById(Long bookId);
    Long getNextId();
}

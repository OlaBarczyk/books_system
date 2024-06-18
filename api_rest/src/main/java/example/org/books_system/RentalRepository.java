package example.org.books_system;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface RentalRepository extends JpaRepository<Rental, Long> {
    List<Rental> findAll();
    List<Rental> findByUserId(Long userId);
    List<Rental> findByBookId(Long bookId);
    List<Rental> findByRentalStatusId(Long rentalStatusId);
    List<Rental> findByRentalDate(LocalDate rentalDate);
    List<Rental> findByReturnDate(LocalDate returnDate);
}

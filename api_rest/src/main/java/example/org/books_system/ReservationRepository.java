package example.org.books_system;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    List<Reservation> findAll();
    List<Reservation> findByUserId(Long userId);
    List<Reservation> findByBookId(Long bookId);
    List<Reservation> findByReservationStatusId(Long reservationStatusId);
    List<Reservation> findByReservationDate(LocalDate reservationDate);
}

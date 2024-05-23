package example.org.books_system;

import java.util.List;

public interface ReservationService {
    List<Reservation> getReservations();
    void addReservation(Reservation reservation);
    void updateReservation(Reservation reservation);
    void deleteReservation(Long id);
    Reservation getReservationById(Long reservationId);
    Long getNextId();
}

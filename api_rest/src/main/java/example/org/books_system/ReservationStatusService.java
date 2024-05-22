package example.org.books_system;

import java.util.List;

public interface ReservationStatusService {
    List<ReservationStatus> getReservationStatuses();
    void addReservationStatus(ReservationStatus reservationStatus);
    void updateReservationStatus(ReservationStatus reservationStatus);
    void deleteReservationStatus(Long id);
    ReservationStatus getReservationStatusById(Long reservationStatusId);
    Long getNextId();
}


package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

@Service
public class ReservationServiceImpl implements ReservationService {
    private final Logger log = LoggerFactory.getLogger(ReservationServiceImpl.class);
    private final List<Reservation> reservations = new ArrayList<>();

    @Override
    public List<Reservation> getReservations() {
        return Collections.unmodifiableList(reservations);
    }

    @Override
    public void addReservation(Reservation reservation) {
        try {
            if (reservation.getId() == null) {
                reservation.setId(getNextId());
            }
            reservations.add(reservation);
            log.info("Reservation has succesfully added: {}", reservation);
        } catch (Exception e) {
            log.error("A server error occurred while adding the rental", e);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Server error occurred");
        }
    }

    @Override
    public void updateReservation(Reservation reservation) {

        Reservation oldReservation = reservations.stream()
                .filter(e -> e.getId().equals(reservation.getId()))
                .findFirst()
                .orElse(null);

        if (oldReservation == null) {
            log.error("Reservation with id {} has not been found", reservation.getId());
            throw new IllegalArgumentException("Reservation with ID " + reservation.getId() + " has not been found for update");
        }
        int index = reservations.indexOf(oldReservation);
        if (index != -1) {
            reservations.set(index, reservation);
            log.info("Reservation has been succesfully updated: {}", reservation);
        } else {
            log.error("Reservation with id {} has not been found", reservation.getId());
        }
    }

    @Override
    public void deleteReservation(Long id) {
        Optional<Reservation> reservationToDelete = reservations.stream()
                .filter(reservation -> reservation.getId().equals(id))
                .findFirst();

        if (reservationToDelete.isPresent()) {
            reservations.remove(reservationToDelete.get());
            log.info("Reservation with id {} has been deleted", id);
        } else {
            log.error("Reservation with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Reservation with ID " + id + " has not been found");
        }
    }

    @Override
    public Reservation getReservationById(Long reservationId) {
        return reservations.stream()
                .filter(reservation -> reservation.getId().equals(reservationId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        return reservations.stream()
                .mapToLong(Reservation::getId)
                .max()
                .orElse(0L) + 1L;
    }

}

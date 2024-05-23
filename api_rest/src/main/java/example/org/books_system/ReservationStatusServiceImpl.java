package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import java.util.ArrayList;
import java.util.List;

@Component
public class ReservationStatusServiceImpl implements ReservationStatusService {

    private final Logger log = LoggerFactory.getLogger(ReservationStatusServiceImpl.class);
    private final List<ReservationStatus> reservationStatuses = new ArrayList<>();
    private final List<Long> deletedIds = new ArrayList<>();
    private Long nextId = 1L;

    @Override
    public List<ReservationStatus> getReservationStatuses() {
        return reservationStatuses;
    }

    @Override
    public void addReservationStatus(ReservationStatus reservationStatus) {
        if (reservationStatus.getStatus() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Status of reservation status is required!.");
        }

        Long id = getNextId();
        reservationStatus.setId(id);
        reservationStatuses.add(reservationStatus);
        log.info("Reservation status has been added successfully: {}", reservationStatus);
    }

    @Override
    public void updateReservationStatus(ReservationStatus reservationStatus) {
        if (reservationStatus.getId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Reservation status id is required.");
        }

        ReservationStatus existingReservationStatus = findReservationStatusById(reservationStatus.getId());
        if (existingReservationStatus == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Reservation status with ID " + reservationStatus.getId() + " has not been found for update");
        }
        existingReservationStatus.setStatus(reservationStatus.getStatus());
        log.info("Reservation status has been updated successfully: {}", reservationStatus);
    }

    private ReservationStatus findReservationStatusById(Long id) {
        return reservationStatuses.stream()
                .filter(reservationStatus -> reservationStatus.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public void deleteReservationStatus(Long id) {
        ReservationStatus reservationStatusToDelete = findReservationStatusById(id);
        if (reservationStatusToDelete == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Reservation status with ID " + id + " has not been found");
        }
        reservationStatuses.remove(reservationStatusToDelete);
        deletedIds.add(id);
        log.info("Reservation status with id {} has been deleted", id);
    }

    @Override
    public ReservationStatus getReservationStatusById(Long reservationStatusId) {
        return reservationStatuses.stream()
                .filter(reservationStatus -> reservationStatus.getId().equals(reservationStatusId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        if (!deletedIds.isEmpty()) {
            Long id = deletedIds.remove(0);
            log.info("Reusing a deleted one ID: {}", id);
            return id;
        }
        return nextId++;
    }
}

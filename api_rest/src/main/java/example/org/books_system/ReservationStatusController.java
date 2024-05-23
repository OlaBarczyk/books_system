package example.org.books_system;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import javax.validation.Valid;
import java.util.List;

@RestController
@Slf4j
public class ReservationStatusController {

    @Autowired
    private ReservationStatusService reservationStatusService;

    @GetMapping("/getReservationStatuses")
    public ResponseEntity<List<ReservationStatus>> getReservationStatuses() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            List<ReservationStatus> reservationStatuses = reservationStatusService.getReservationStatuses();
            return new ResponseEntity<>(reservationStatuses, HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addReservationStatus")
    public ResponseEntity<String> addReservationStatus(@Valid @RequestBody ReservationStatus reservationStatus) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to add reservation status was received: {}", reservationStatus);
            reservationStatusService.addReservationStatus(reservationStatus);
            log.info("Reservation status successfully added: {}", reservationStatus);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updateReservationStatus")
    public ResponseEntity<String> updateReservationStatus(@Valid @RequestBody ReservationStatus reservationStatus) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to update the reservation status has been received: {}", reservationStatus);
            reservationStatusService.updateReservationStatus(reservationStatus);
            log.info("Reservation status successfully updated: {}", reservationStatus);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deleteReservationStatus/{id}")
    public ResponseEntity<String> deleteReservationStatus(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to delete the reservation status has been received with ID: {}", id);
            reservationStatusService.deleteReservationStatus(id);
            log.info("Reservation status with ID {} deleted successfully", id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }
}

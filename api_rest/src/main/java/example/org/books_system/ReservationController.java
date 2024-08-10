package example.org.books_system;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;
import java.util.List;

@RestController
@Slf4j
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @GetMapping("/getReservations")
    public ResponseEntity<List<Reservation>> getReservations() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER") || authority.getAuthority().equals("ROLE_ADMIN"))) {
            List<Reservation> reservations = reservationService.getReservations();
            return new ResponseEntity<>(reservations, HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addReservation")
    public ResponseEntity<String> addReservation(@Valid @RequestBody Reservation reservation) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            if (reservation.getReservationDate() == null || reservation.getUser() == null || reservation.getBook() == null || reservation.getReservationStatus() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: All the fields are required.");
            }
            reservationService.addReservation(reservation);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updateReservation")
    public ResponseEntity<String> updateReservation(@Valid @RequestBody Reservation reservation) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            if (reservation.getId() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Reservation ID is required for update");
            }
            reservationService.updateReservation(reservation);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deleteReservation/{id}")
    public ResponseEntity<String> deleteReservation(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            reservationService.deleteReservation(id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }
}

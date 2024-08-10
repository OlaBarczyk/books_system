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
public class RentalController {

    @Autowired
    private RentalService rentalService;

    @GetMapping("/getRentals")
    public ResponseEntity<List<Rental>> getRentals() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER") || authority.getAuthority().equals("ROLE_ADMIN"))) {
            List<Rental> rentals = rentalService.getRentals();
            return new ResponseEntity<>(rentals, HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addRental")
    public ResponseEntity<String> addRental(@Valid @RequestBody Rental rental) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to add a rental has been received: {}", rental.getRentalDate());

            if (rental.getRentalDate() == null || rental.getUser() == null || rental.getBook() == null || rental.getRentalStatus() == null || rental.getReturnDate() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: All the fields are required.");
            }
            rentalService.addRental(rental);
            log.info("Rental has added successfully: {}", rental);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updateRental")
    public ResponseEntity<String> updateRental(@Valid @RequestBody Rental rental) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to update the rental has been received: {}", rental.getRentalDate());

            if (rental.getId() == null) {
                log.error("The rental requires an ID to be updated (ID)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Rental ID is required for update");
            }
            rentalService.updateRental(rental);
            log.info("The rental has been successfully updated: {}", rental);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deleteRental/{id}")
    public ResponseEntity<String> deleteRental(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request has been received to remove the rental with id: {}", id);

            rentalService.deleteRental(id);
            log.info("Rental with id {} has successfully deleted", id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }
}

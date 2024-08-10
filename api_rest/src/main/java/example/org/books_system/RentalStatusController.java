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
public class RentalStatusController {

    @Autowired
    private RentalStatusService rentalStatusService;

    @GetMapping("/getRentalStatuses")
    public ResponseEntity<List<RentalStatus>> getRentalStatuses() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER") || authority.getAuthority().equals("ROLE_ADMIN"))) {
            List<RentalStatus> rentalStatuses = rentalStatusService.getRentalStatuses();
            return new ResponseEntity<>(rentalStatuses, HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addRentalStatus")
    public ResponseEntity<String> addRentalStatus(@Valid @RequestBody RentalStatus rentalStatus) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to add rental status was received: {}", rentalStatus);
            rentalStatusService.addRentalStatus(rentalStatus);
            log.info("Rental status successfully added: {}", rentalStatus);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updateRentalStatus")
    public ResponseEntity<String> updateRentalStatus(@Valid @RequestBody RentalStatus rentalStatus) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to update the rental status has been received: {}", rentalStatus);
            rentalStatusService.updateRentalStatus(rentalStatus);
            log.info("Rental status successfully updated: {}", rentalStatus);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deleteRentalStatus/{id}")
    public ResponseEntity<String> deleteRentalStatus(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to delete the rental status has been received with ID: {}", id);
            rentalStatusService.deleteRentalStatus(id);
            log.info("Rental status with ID {} deleted successfully", id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }
}

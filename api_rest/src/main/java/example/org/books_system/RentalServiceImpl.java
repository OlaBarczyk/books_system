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
public class RentalServiceImpl implements RentalService {
    private final Logger log = LoggerFactory.getLogger(RentalServiceImpl.class);
    private final List<Rental> rentals = new ArrayList<>();

    @Override
    public List<Rental> getRentals() {
        return Collections.unmodifiableList(rentals);
    }

    @Override
    public void addRental(Rental rental) {
        try {
            if (rental.getId() == null) {
                rental.setId(getNextId());
            }
            rentals.add(rental);
            log.info("Rental has succesfully added: {}", rental);
        } catch (Exception e) {
            log.error("A server error occurred while adding the rental", e);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Server error occurred");
        }
    }

    @Override
    public void updateRental(Rental rental) {

        Rental oldRental = rentals.stream()
                .filter(e -> e.getId().equals(rental.getId()))
                .findFirst()
                .orElse(null);

        if (oldRental == null) {
            log.error("Rental with id {} has not been found", rental.getId());
            throw new IllegalArgumentException("Rental with ID " + rental.getId() + " has not been found for update");
        }
        int index = rentals.indexOf(oldRental);
        if (index != -1) {
            rentals.set(index, rental);
            log.info("Rental has been succesfully updated: {}", rental);
        } else {
            log.error("Rental with id {} has not been found", rental.getId());
        }
    }

    @Override
    public void deleteRental(Long id) {
        Optional<Rental> rentalToDelete = rentals.stream()
                .filter(rental -> rental.getId().equals(id))
                .findFirst();

        if (rentalToDelete.isPresent()) {
            rentals.remove(rentalToDelete.get());
            log.info("Rental with id {} has been deleted", id);
        } else {
            log.error("Rental with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Rental with ID " + id + " has not been found");
        }
    }

    @Override
    public Rental getRentalById(Long rentalId) {
        return rentals.stream()
                .filter(rental -> rental.getId().equals(rentalId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        return rentals.stream()
                .mapToLong(Rental::getId)
                .max()
                .orElse(0L) + 1L;
    }

}

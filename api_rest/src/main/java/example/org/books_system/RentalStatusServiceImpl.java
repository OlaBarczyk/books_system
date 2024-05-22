package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import java.util.ArrayList;
import java.util.List;

@Component
public class RentalStatusServiceImpl implements RentalStatusService {

    private final Logger log = LoggerFactory.getLogger(RentalStatusServiceImpl.class);
    private final List<RentalStatus> rentalStatuses = new ArrayList<>();
    private final List<Long> deletedIds = new ArrayList<>();
    private Long nextId = 1L;

    @Override
    public List<RentalStatus> getRentalStatuses() {
        return rentalStatuses;
    }

    @Override
    public void addRentalStatus(RentalStatus rentalStatus) {
        if (rentalStatus.getStatus() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Status of rental status is required!.");
        }
        Long id = getNextId();
        rentalStatus.setId(id);
        rentalStatuses.add(rentalStatus);
        log.info("Rental status has been added successfully: {}", rentalStatus);
    }

    @Override
    public void updateRentalStatus(RentalStatus rentalStatus) {
        if (rentalStatus.getId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Rental status id is required.");
        }
        RentalStatus existingRentalStatus = findRentalStatusById(rentalStatus.getId());
        if (existingRentalStatus == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Rental status with ID " + rentalStatus.getId() + " has not been found for update");
        }
        existingRentalStatus.setStatus(rentalStatus.getStatus());
        log.info("Rental status has been updated successfully: {}", rentalStatus);
    }

    private RentalStatus findRentalStatusById(Long id) {
        return rentalStatuses.stream()
                .filter(rentalStatus -> rentalStatus.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public void deleteRentalStatus(Long id) {
        RentalStatus rentalStatusToDelete = findRentalStatusById(id);
        if (rentalStatusToDelete == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Rental status with ID " + id + " has not been found");
        }
        rentalStatuses.remove(rentalStatusToDelete);
        deletedIds.add(id);
        log.info("Rental status with id {} has been deleted", id);
    }

    @Override
    public RentalStatus getRentalStatusById(Long rentalStatusId) {
        return rentalStatuses.stream()
                .filter(rentalStatus -> rentalStatus.getId().equals(rentalStatusId))
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

package example.org.books_system;

import java.util.List;

public interface RentalStatusService {
    List<RentalStatus> getRentalStatuses();
    void addRentalStatus(RentalStatus rentalStatus);
    void updateRentalStatus(RentalStatus rentalStatus);
    void deleteRentalStatus(Long id);
    RentalStatus getRentalStatusById(Long rentalStatusId);
    Long getNextId();
}

package example.org.books_system;

import java.util.List;

public interface RentalService {
    List<Rental> getRentals();
    void addRental(Rental rental);
    void updateRental(Rental rental);
    void deleteRental(Long id);
    Rental getRentalById(Long rentalId);
    Long getNextId();
}

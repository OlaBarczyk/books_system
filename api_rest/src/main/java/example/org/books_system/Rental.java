package example.org.books_system;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import lombok.Getter;
import lombok.Setter;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;


@Entity
@JsonInclude(Include.NON_NULL)
public class Rental {

    @Getter
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @JsonProperty("id")
    private Long id;


    @Setter
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_id")
    @JsonProperty("book")
    private Book book;

    @Setter
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    @JsonProperty("user")
    private User user;

    @Setter
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "rental_status_id")
    @JsonProperty("rentalStatus")
    private RentalStatus rentalStatus;

    @Setter
    @NotNull
    @JsonProperty("rental_date")
    private LocalDate rentalDate;

    @Setter
    @NotNull
    @JsonProperty("return_date")
    private LocalDate returnDate;

    public Book getBook() {
        return book;
    }

    public User getUser() {
        return user;
    }

    public RentalStatus getRentalStatus() {
        return rentalStatus;
    }

    public LocalDate getRentalDate() {
        return rentalDate;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }

    public void setId(Long id) {
        // Validation of incoming ID before setting
        if (id != null) {
            this.id = id;
        } else {
            throw new IllegalArgumentException("Queue ID must not be null!");
        }
    }
}





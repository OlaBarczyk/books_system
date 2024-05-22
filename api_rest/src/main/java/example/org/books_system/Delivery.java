package example.org.books_system;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import lombok.Getter;
import lombok.Setter;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;

@Getter
@Entity
@JsonInclude(Include.NON_NULL)
public class Delivery {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @JsonProperty("id")
    private Long id;

    @Setter
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    @JsonProperty("user")
    private User user;

    @Setter
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_id")
    @JsonProperty("book")
    private Book book;

    @Setter
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "delivery_status_id")
    @JsonProperty("deliveryStatus")
    private DeliveryStatus deliveryStatus;

    @Setter
    @NotNull
    @JsonProperty("delivery_date")
    private LocalDate deliveryDate;

    public void setId(Long id) {
        // Validation of incoming ID before setting
        if (id != null) {
            this.id = id;
        } else {
            throw new IllegalArgumentException("Delivery ID must not be null!");
        }
    }
}

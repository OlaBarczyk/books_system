package example.org.books_system;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import lombok.Getter;
import lombok.Setter;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@JsonInclude(Include.NON_NULL)
public class Payment {

    @Getter
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
    @JoinColumn(name = "payment_status_id")
    @JsonProperty("paymentStatus")
    private PaymentStatus paymentStatus;


    @Setter
    @NotNull
    @JsonProperty("payment_date")
    private LocalDate paymentDate;

    @Setter
    @NotNull
    @JsonProperty("amount")
    private BigDecimal amount;

    public LocalDate getPaymentDate() {
        return paymentDate;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public User getUser() {
        return user;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setId(Long id) {
        // Validation of incoming ID before setting
        if (id != null) {
            this.id = id;
        } else {
            throw new IllegalArgumentException("Payment ID must not be null!");
        }
    }
}



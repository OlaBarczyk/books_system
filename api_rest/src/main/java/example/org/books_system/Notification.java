package example.org.books_system;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import lombok.Getter;
import lombok.Setter;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;

@Entity
@JsonInclude(Include.NON_NULL)
public class Notification {

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
    @JoinColumn(name = "notification_type_id")
    @JsonProperty("notificationType")
    private NotificationType notificationType;

    @Setter
    @NotNull
    @JsonProperty("sending_date")
    private LocalDate sendingDate;

    @Getter
    @Setter
    @NotBlank
    @JsonProperty("message")
    public String message;

    public String getMessage() {
        return message;
    }

    public LocalDate getSendingDate() {
        return sendingDate;
    }

    public User getUser() {
        return user;
    }

    public NotificationType getNotificationType() {
        return notificationType;
    }

    public void setId(Long id) {
        // Validation of incoming ID before setting
        if (id != null) {
            this.id = id;
        } else {
            throw new IllegalArgumentException("Notification ID must not be null!");
        }
    }
}


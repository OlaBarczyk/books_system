package example.org.books_system;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import javax.validation.constraints.NotBlank;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import lombok.Getter;
import lombok.Setter;

@Getter
@Entity
@JsonInclude(Include.NON_NULL)
public class Author {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)

    @JsonProperty("id")
    private Long id;

    @Setter
    @JsonProperty("firstName")
    @NotBlank
    private String firstName;
    @Setter
    @JsonProperty("lastName")
    @NotBlank
    private String lastName;

    public void setId(Long id) {
        // Validation of incoming ID before setting
        if (id != null) {
            this.id = id;
        } else {
            throw new IllegalArgumentException("The author ID cannot be null");
        }
    }

}
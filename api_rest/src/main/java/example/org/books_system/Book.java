package example.org.books_system;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import lombok.Getter;
import lombok.Setter;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Entity
@JsonInclude(Include.NON_NULL)
public class Book {

    @Getter
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @JsonProperty("id")
    private Long id;


    @Getter
    @Setter
    @NotBlank
    @JsonProperty("title")
    public String title;

    @Setter
    @Getter
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "author_id")
    @JsonProperty("author")
    private Author author;

    @Setter
    @Getter
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "publisher_id")
    @JsonProperty("publisher")
    private Publisher publisher;

    @Setter
    @Getter
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "genre_id")
    @JsonProperty("genre")
    private Genre genre;

    @NotNull
    @JsonProperty("isbn")
    private long ISBN;

    @Setter
    @Getter
    @NotNull
    @JsonProperty("number_of_pages")
    private Integer numberOfPages;

    public void setISBN(long isbn) {
        this.ISBN = ISBN;
    }

    public long getISBN() {
        return ISBN;
    }


    public void setId(Long id) {
        // Validation of incoming ID before setting
        if (id != null) {
            this.id = id;
        } else {
            throw new IllegalArgumentException("Book ID must not be null!");
        }
    }
}

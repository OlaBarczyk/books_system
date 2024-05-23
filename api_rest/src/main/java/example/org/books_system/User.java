package example.org.books_system;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import javax.validation.constraints.NotBlank;
import java.util.Collections;
import java.util.List;

@Entity
@JsonInclude(JsonInclude.Include.NON_NULL)
public class User {

    @Getter
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @JsonProperty("id")
    private Long id;

    @Setter
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "role_id", referencedColumnName = "id")
    @JsonProperty("role")
    private Role role;

    @Getter
    @Setter
    @NotBlank
    @JsonProperty("first_name")
    public String firstName;

    @Getter
    @Setter
    @NotBlank
    @JsonProperty("last_name")
    public String lastName;

    @Getter
    @Setter
    @NotBlank
    @JsonProperty("username")
    public String username;

    @Getter
    @Setter
    @NotBlank
    @JsonProperty("password")
    public String password;

    @Getter
    @Setter
    @NotBlank
    @JsonProperty("token")
    public String token;

    @Getter
    @Setter
    @NotBlank
    @JsonProperty("email")
    public String email;

    @Getter
    @Setter
    @NotBlank
    @JsonProperty("phone")
    public String phone;

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public Role getRole() {
        return role;
    }

    public void setId(Long id) {
        // Validation of incoming ID before setting
        if (id!= null) {
            this.id = id;
        } else {
            throw new IllegalArgumentException("User ID must not be null!");
        }
    }

    public List<SimpleGrantedAuthority> getAuthorities() {
        if (role!= null) {
            return Collections.singletonList(new SimpleGrantedAuthority(role.getName()));
        } else {
            return Collections.emptyList();
        }
    }
}

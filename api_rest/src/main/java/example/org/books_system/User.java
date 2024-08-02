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
    @JsonProperty("login")
    public String login;

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
    @JsonProperty("salt")
    public String salt;


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

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
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

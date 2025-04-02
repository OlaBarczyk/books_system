package example.org.books_system;

import io.micrometer.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;


@RestController
@RequestMapping("/login")
public class LoginController {

    @Autowired
    BookRepository bookRepository;

    @GetMapping("/test")
    public String getTest(@RequestParam Optional<String> name) {
        return "Hello " + name.orElse("User");
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> getTestLogin(@RequestBody LoginRequest request) {
        Map<String, String> response = new HashMap<>();

        System.out.println("Login: " + request.getLogin());
        System.out.println("Password: " + request.getPassword());

        if (StringUtils.isEmpty(request.getLogin()) || StringUtils.isEmpty(request.getPassword())) {
            response.put("message", "Podaj login i hasło!");
            return ResponseEntity.status(400).body(response);
        } else if ("test".equals(request.getLogin()) && "1234".equals(request.getPassword())) {
            response.put("message", "Poprawne dane!");
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "Zły login lub hasło!");
            return ResponseEntity.status(401).body(response);
        }
    }


    @GetMapping("/books")
    public List<Ksiazki> getAllBooks() {

        return bookRepository.getAll();
    }

    public static class LoginRequest {
        private String login;
        private String password;

        // Getters
        public String getLogin() {
            return login;
        }

        public String getPassword() {
            return password;
        }

        // Setters
        public void setLogin(String login) {
            this.login = login;
        }

        public void setPassword(String password) {
            this.password = password;
        }



    }

}

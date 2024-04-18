package example.org.books_system;

import io.micrometer.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;


@RestController
public class  LoginController {

    @Autowired
    private BookService bookService;

    @GetMapping("/test")
    public String getTest(@RequestParam(required = false) String name) {
        return "Hello " + Optional.ofNullable(name).orElse("User");
    }


    @PostMapping("/test")
    public String postTest(@RequestBody String name) {
        return "Hello " + name;
    }

    // Helper method for generating login response
    private ResponseEntity<Map<String, String>> generateLoginResponse(String message, HttpStatus httpStatus) {
        Map<String, String> response = new HashMap<>();
        response.put("message", message);
        return new ResponseEntity<>(response, httpStatus);
    }

    @GetMapping("/login")
    public ResponseEntity<Map<String, String>> getTestLogin(
            @RequestParam(required = false) String login,
            @RequestParam(required = false) String password) {

        if (StringUtils.isEmpty(login) || StringUtils.isEmpty(password)) {
            return generateLoginResponse("Podaj login i hasło!", HttpStatus.BAD_REQUEST);
        } else if ("test".equals(login) && "123456".equals(password)) {
            return generateLoginResponse("Poprawne dane!", HttpStatus.OK);
        } else {
            return generateLoginResponse("Zły login lub hasło!", HttpStatus.UNAUTHORIZED);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> postLogin(@RequestBody LoginRequest loginRequest) {

        if (loginRequest.getUsername() == null || loginRequest.getUsername().isEmpty() ||
                loginRequest.getPassword() == null || loginRequest.getPassword().isEmpty()) {
            return generateLoginResponse("Podaj login i hasło!", HttpStatus.BAD_REQUEST);
        } else if ("test".equals(loginRequest.getUsername()) && "1234".equals(loginRequest.getPassword())) {
            return generateLoginResponse("Poprawne dane!", HttpStatus.OK);
        } else {
            return generateLoginResponse("Zły login lub hasło!", HttpStatus.UNAUTHORIZED);
        }
    }


    // Add a book to the array

}



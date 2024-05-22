package example.org.books_system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@RestController
public class LoginController {

    @Autowired
    private BookService bookService;

    @GetMapping("/home")
    public String handleWelcome(@RequestHeader(HttpHeaders.AUTHORIZATION) String authValue) {
        if (authValue != null && authValue.startsWith("Basic ")) {
            String decodedAuth = new String(Base64.getDecoder().decode(authValue.substring(6)));
            String[] credentials = decodedAuth.split(":");
            if (credentials.length == 2 && credentials[0].equals("test") && credentials[1].equals("123456")) {
                return "home";
            }
        }
        return "Access denied";
    }

    @GetMapping("/admin/home")
    public String handleAdminHome() {
        return "home_admin";
    }

    @GetMapping("/user/home")
    public String handleUserHome() {
        return "home_user";
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> postLogin(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authValue) {
        if (authValue!= null && authValue.startsWith("Basic ")) {
            String decodedAuth = new String(Base64.getDecoder().decode(authValue.substring(6)));
            String[] credentials = decodedAuth.split(":");
            if (credentials.length == 2 && "test".equals(credentials[0]) && "123456".equals(credentials[1])) {
                return generateLoginResponse("Logged in successfully", HttpStatus.OK);
            }
        }
        return generateLoginResponse("Wrong login or password!!!", HttpStatus.UNAUTHORIZED);
    }

    // Helper method for generating login response
    private ResponseEntity<Map<String, String>> generateLoginResponse(String message, HttpStatus httpStatus) {
        Map<String, String> response = new HashMap<>();
        response.put("message", message);
        return new ResponseEntity<>(response, httpStatus);
    }
}

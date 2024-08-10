package example.org.books_system;

import example.org.books_system.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
public class LoginController {

    @Autowired
    private LoginService loginService;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private UserDetailsService userDetailsService;

    @GetMapping("/home")
    @PreAuthorize("isAuthenticated()")
    public String handleWelcome() {
        return "home";
    }

    @GetMapping("/admin/home")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public String handleAdminHome() {
        /*Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER") || authority.getAuthority().equals("ROLE_ADMIN"))) {
            return "home_admin";
        }
        return "You must be admin!";
        */
         return "Success!";
    }

    @GetMapping("/user/home")
    @PreAuthorize("hasRole('ROLE_USER')")
    public String handleUserHome() {
        return "home_user";
    }

    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@RequestBody LoginRequest loginRequest) {
        if (!loginService.login(loginRequest.getLogin(), loginRequest.getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid username or password");
        }

        UserDetails userDetails = userDetailsService.loadUserByUsername(loginRequest.getLogin());
        String jwt = jwtUtils.generateToken(userDetails);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Login successful!");
        response.put("jwt", jwt);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/register")
    public ResponseEntity<RegisterResponse> postRegister(@RequestBody RegisterRequest registerRequest) {
        return ResponseEntity.ok(loginService.register(registerRequest));
    }
}

package example.org.books_system;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;
import java.util.List;

@RestController
@Slf4j
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/getUsers")
    public ResponseEntity<List<User>> getUsers() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER") || authority.getAuthority().equals("ROLE_ADMIN"))) {
            List<User> users = userService.getUsers();
            return new ResponseEntity<>(users, HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addUser")
    public ResponseEntity<String> addUser(@Valid @RequestBody User user) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to add a user has been received: {}", user.getLogin());
            if (user.getLogin() == null || user.getPassword() == null || user.getToken() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: All the fields are required.");
            }
            userService.addUser(user);
            log.info("User has added successfully: {}", user);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updateUser")
    public ResponseEntity<String> updateUser(@Valid @RequestBody User user) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to update the user has been received: {}", user.getLogin());
            if (user.getId() == null) {
                log.error("The user requires an ID to be updated (ID)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("User ID is required for update");
            }
            userService.updateUser(user);
            log.info("The user has been successfully updated: {}", user);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deleteUser/{id}")
    public ResponseEntity<String> deleteUser(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request has been received to remove the user with id: {}", id);
            userService.deleteUser(id);
            log.info("User with id {} has successfully deleted", id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }
}

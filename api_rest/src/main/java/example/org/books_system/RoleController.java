package example.org.books_system;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import javax.validation.Valid;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

// We add import for DefaultMessageSourceResolvable
import org.springframework.context.MessageSourceResolvable;

@RestController
@Slf4j
public class RoleController {

    @Autowired
    private RoleService roleService;

    @GetMapping("/getRoles")
    public ResponseEntity<List<Role>> getRoles() {
        List<Role> roles = roleService.getRoles();
        return new ResponseEntity<>(roles, HttpStatus.OK);
    }

    @PutMapping("/addRole")
    public ResponseEntity<String> addRole(@Valid @RequestBody Role role) {
        log.info("A request to add a role was received: {}", role);
        roleService.addRole(role);
        log.info("\n" +
                "Role successfully added\n: {}", role);
        return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
    }

    @PostMapping("/updateRole")
    public ResponseEntity<String> updateRole(@Valid @RequestBody Role role) {
        log.info("A role update request was received: {}", role);
        roleService.updateRole(role);
        log.info("Role successfully updated: {}", role);
        return ResponseEntity.status(HttpStatus.OK).body("Updated!");
    }

    @DeleteMapping("/deleteRole/{id}")
    public ResponseEntity<String> deleteRole(@PathVariable Long id) {
        log.info("A request to delete a role was received with ID: {}", id);
        roleService.deleteRole(id);
        log.info("Role with ID {} deleted successfully", id);
        return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<String> handleValidationExceptions(MethodArgumentNotValidException ex) {
        String errorMessage = ex.getBindingResult().getAllErrors().stream()
                .map(MessageSourceResolvable::getDefaultMessage)
                .collect(Collectors.joining(", "));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: " + errorMessage);
    }
}

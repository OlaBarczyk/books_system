package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import java.util.ArrayList;
import java.util.List;

@Component
public class RoleServiceImpl implements RoleService {

    private final Logger log = LoggerFactory.getLogger(RoleServiceImpl.class);
    private final List<Role> roles = new ArrayList<>();
    private Long nextId = 1L;

    @Override
    public List<Role> getRoles() {
        return roles;
    }

    @Override
    public void addRole(Role role) {
        if (role.getName() == null || role.getName().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Role's name is required.");
        }
        if (role.getDescription() == null || role.getDescription().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Role's description is required.");
        }
        role.setId(nextId++);
        roles.add(role);
        log.info("Role successfully added: {}", role);
    }

    @Override
    public void updateRole(Role role) {
        Role existingRole = findRoleById(role.getId());
        if (existingRole == null) {
            log.error("Role with id {} has not been found", role.getId());
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Role with ID" + role.getId() + " has not been found for update");
        }

        // Check that all required fields are present
        if (role.getName() == null || role.getName().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Role's name is required.");
        }
        if (role.getDescription() == null || role.getDescription().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Validation error: Role's description is required.");
        }

        existingRole.setName(role.getName());
        existingRole.setDescription(role.getDescription());
        log.info("Role updated successfully: {}", role);
    }

    @Override
    public void deleteRole(Long id) {
        Role roleToDelete = findRoleById(id);
        if (roleToDelete == null) {
            log.error("Role with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Role with ID " + id + " has not been found");
        }
        roles.remove(roleToDelete);
        log.info("Role with id {} has been deleted", id);
    }

    private Role findRoleById(Long id) {
        return roles.stream()
                .filter(role -> role.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Role getRoleById(Long roleId) {
        return roles.stream()
                .filter(role -> role.getId().equals(roleId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        return roles.stream()
                .map(Role::getId)
                .max(Long::compare)
                .orElse(0L) + 1;
    }
}


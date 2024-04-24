package example.org.books_system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

public interface RoleService {
    List<Role> getRoles();
    void addRole(Role role);
    void updateRole(Role role);
    void deleteRole(Long id);

    Role getRoleById(Long roleId);

    Long getNextId();
}



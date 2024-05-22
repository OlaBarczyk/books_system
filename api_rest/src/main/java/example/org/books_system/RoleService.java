package example.org.books_system;

import java.util.List;

public interface RoleService {
    List<Role> getRoles();
    void addRole(Role role);
    void updateRole(Role role);
    void deleteRole(Long id);
    Role getRoleById(Long roleId);
    Long getNextId();
}



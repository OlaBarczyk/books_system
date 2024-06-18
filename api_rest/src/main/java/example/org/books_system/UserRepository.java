package example.org.books_system;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findAll();
    List<User> findByRoleId(Long roleId);
    List<User> findByFirstName(String firstName);
    List<User> findByLastName(String lastName);
    List<User> findByUsername(String username);
    List<User> findByPassword(String password);
    List<User> findByToken(String token);
    List<User> findByEmail(String email);
    List<User> findByPhone(String phone);
}

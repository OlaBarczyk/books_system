package example.org.books_system;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findAll();
    List<User> findByRoleId(Long roleId);
    List<User> findByLogin(String login);
    List<User> findByPassword(String password);
    List<User> findByToken(String token);
}

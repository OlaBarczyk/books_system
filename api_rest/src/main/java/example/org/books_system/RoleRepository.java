package example.org.books_system;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
public interface RoleRepository extends JpaRepository<Role, Long> {
    List<Role> findByName(String name);
}

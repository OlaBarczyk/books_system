package example.org.books_system;

import java.util.List;

public interface UserService {
    List<User> getUsers();
    void addUser(User user);
    void updateUser(User user);
    void deleteUser(Long id);
    User getUserById(Long userId);
    Long getNextId();
}


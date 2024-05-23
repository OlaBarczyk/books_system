package example.org.books_system;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

@Service
public class UserServiceImpl implements UserService {
    private final Logger log = LoggerFactory.getLogger(UserServiceImpl.class);
    private final List<User> users = new ArrayList<>();

    @Override
    public List<User> getUsers() {
        return Collections.unmodifiableList(users);
    }

    @Override
    public void addUser(User user) {
        try {
            if (user.getId() == null) {
                user.setId(getNextId());
            }
            users.add(user);
            log.info("User has succesfully added: {}", user);
        } catch (Exception e) {
            log.error("A server error occurred while adding the user", e);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Server error occurred");
        }
    }

    @Override
    public void updateUser(User user) {

        User oldUser = users.stream()
                .filter(e -> e.getId().equals(user.getId()))
                .findFirst()
                .orElse(null);

        if (oldUser== null) {
            log.error("User with id {} has not been found", user.getId());
            throw new IllegalArgumentException("User with ID " + user.getId() + " has not been found for update");
        }

        int index = users.indexOf(oldUser);
        if (index != -1) {
            users.set(index, user);
            log.info("User has been succesfully updated: {}", user);
        } else {
            log.error("User with id {} has not been found", user.getId());
        }
    }

    @Override
    public void deleteUser(Long id) {
        Optional<User> userToDelete = users.stream()
                .filter(user -> user.getId().equals(id))
                .findFirst();

        if (userToDelete.isPresent()) {
            users.remove(userToDelete.get());
            log.info("User with id {} has been deleted", id);
        } else {
            log.error("User with id {} has not been found", id);
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User with ID " + id + " has not been found");
        }
    }

    @Override
    public User getUserById(Long userId) {
        return users.stream()
                .filter(user -> user.getId().equals(userId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public Long getNextId() {
        return users.stream()
                .mapToLong(User::getId)
                .max()
                .orElse(0L) + 1L;
    }
}


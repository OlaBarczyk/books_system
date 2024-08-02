package example.org.books_system;

import example.org.books_system.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class LoginServiceImpl implements LoginService {

    private final UserDetailsService userDetailsService;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public LoginServiceImpl(UserDetailsService userDetailsService, PasswordEncoder passwordEncoder) {
        this.userDetailsService = userDetailsService;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public RegisterResponse register(RegisterRequest registerRequest) {
        String encodedPassword = passwordEncoder.encode(registerRequest.getPassword());
        System.out.println("role: " + registerRequest.getRole());
        UserDetails user = User.builder()
                .username(registerRequest.getLogin())
                .password(encodedPassword)
                .roles(registerRequest.getRole().toUpperCase())
                .build();
        ((InMemoryUserDetailsManager) userDetailsService).createUser(user);
        return new RegisterResponse("Register successful!");
    }

    @Override
    public boolean login(String login, String password) {
        UserDetails userDetails = userDetailsService.loadUserByUsername(login);
        return passwordEncoder.matches(password, userDetails.getPassword());
    }
}

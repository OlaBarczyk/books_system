package example.org.books_system.config;

import example.org.books_system.utils.JwtUtils;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.userdetails.UserDetailsService;

@Configuration
public class CustomJwtAuthenticationFilterConfig {
    @Bean
    public CustomJwtAuthenticationFilter customJwtAuthenticationFilter() {
        return new CustomJwtAuthenticationFilter();
    }
}

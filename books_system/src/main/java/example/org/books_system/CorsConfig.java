package example.org.books_system;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")  // Dla wszystkich endpointów
                .allowedOrigins("http://localhost:3000")  // Dodaj frontendowy adres (port może się różnić w zależności od środowiska)
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);  // Jeśli potrzebujesz obsługi ciasteczek sesyjnych
    }
}
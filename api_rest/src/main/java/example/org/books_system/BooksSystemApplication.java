package example.org.books_system;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@SpringBootApplication
@EntityScan("example.org.books_system")
public class BooksSystemApplication {

	public static void main(String[] args) {
		SpringApplication.run(BooksSystemApplication.class, args);
	}

}

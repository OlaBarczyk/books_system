package example.org.books_system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.awt.print.Book;
import java.util.List;

@Repository
public class BookRepository {

    @Autowired
    JdbcTemplate jdbcTemplate;

    public List<Ksiazki> getAll() {

        return jdbcTemplate.query("SELECT * FROM Ksiazki",
                BeanPropertyRowMapper.newInstance(Ksiazki.class));


        }


    }


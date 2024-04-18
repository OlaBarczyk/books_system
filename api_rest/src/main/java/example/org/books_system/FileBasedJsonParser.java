package example.org.books_system;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class FileBasedJsonParser {
    private final String filePath;

    public FileBasedJsonParser(String filePath) {
        this.filePath = filePath;
    }

    public InputStream parse() throws IOException {

        FileInputStream inputStream = new FileInputStream(filePath);

        return inputStream;
    }
}

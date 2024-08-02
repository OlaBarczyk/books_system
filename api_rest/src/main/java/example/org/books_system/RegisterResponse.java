package example.org.books_system;

public class RegisterResponse {
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    private String message;
    RegisterResponse(String message) {
        this.message = message;
    }
}

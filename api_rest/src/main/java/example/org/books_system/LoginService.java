package example.org.books_system;

public interface LoginService  {
    RegisterResponse register(RegisterRequest request);
    boolean login(String login, String password);
}

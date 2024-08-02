package example.org.books_system.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import java.security.Key;
import java.util.List;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Component
public class JwtUtils {

    private static final Logger logger = LoggerFactory.getLogger(JwtUtils.class);
    private static final Key SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS256);

    public String generateToken(UserDetails userDetails) {
        logger.info("Generating JWT token with SECRET_KEY: {}", Base64.getEncoder().encodeToString(SECRET_KEY.getEncoded()));

        String token = Jwts.builder()
                .setSubject(userDetails.getUsername())
                .claim("roles", userDetails.getAuthorities().stream()
                        .map(GrantedAuthority::getAuthority)
                        .collect(Collectors.toList()))
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 3600000)) // 1 hour validity
                .signWith(SECRET_KEY, SignatureAlgorithm.HS256)
                .compact();
        logger.info("Generated JWT token for user: {}", userDetails.getUsername());
        return token;
    }

    public boolean validateToken(String token) {
        try {
            logger.info("Validating JWT token with SECRET_KEY: {}", Base64.getEncoder().encodeToString(SECRET_KEY.getEncoded()));

            Jwts.parserBuilder().setSigningKey(SECRET_KEY).build().parseClaimsJws(token);
            logger.info("JWT token is valid.");
            return true;
        } catch (Exception e) {
            logger.error("JWT token is invalid.", e);
            return false;
        }
    }

    public String getUsernameFromToken(String token) {
        Claims claims = Jwts.parserBuilder().setSigningKey(SECRET_KEY).build().parseClaimsJws(token).getBody();
        String username = claims.getSubject();
        logger.info("Extracted username from JWT token: {}", username);
        return username;
    }

    public List<String> getRolesFromToken(String token) {
        Claims claims = getAllClaimsFromToken(token);
        List<String> roles = claims.get("roles", List.class);
        logger.info("Extracted roles from JWT token: {}", roles);
        return roles;
    }

    private Claims getAllClaimsFromToken(String token) {
        return Jwts.parserBuilder().setSigningKey(SECRET_KEY).build().parseClaimsJws(token).getBody();
    }
}
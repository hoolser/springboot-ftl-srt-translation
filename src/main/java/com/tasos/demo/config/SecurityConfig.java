package com.tasos.demo.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.header.writers.StaticHeadersWriter;

import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Value("${app.security.username}")
    private String username;

    @Value("${app.security.password}")
    private String password;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf
                        // Disable CSRF for blob storage endpoints (they don't require authentication)
                        .ignoringRequestMatchers("/api/storage/blobs/**", "/api/admin/storage/blobs/**", "/api/courses/**")
                )
                .authorizeHttpRequests(authorizeRequests ->
                        authorizeRequests
                                // Allow blob storage endpoints without authentication
                                .requestMatchers("/api/storage/blobs/**").permitAll()
                                // Login page is accessible without authentication
                                .requestMatchers("/login").permitAll()
                                // Error pages must be accessible without authentication
                                .requestMatchers("/error", "/error/**").permitAll()
                                .requestMatchers("/admin-contact/**").permitAll()
                                // Only SRT translation endpoints and Admin storage require ADMIN role
                                .requestMatchers("/api/srt/translation/**", "/srt-translation-page", "/api/admin/storage/blobs/**", "/admin-share-file-blob", "/admin/browser/**", "/admin-email/**").hasRole("ADMIN")
                                // Opensearch endpoints
                                .requestMatchers(org.springframework.http.HttpMethod.POST, "/api/courses/**").hasRole("ADMIN")
                                .requestMatchers(org.springframework.http.HttpMethod.DELETE, "/api/courses/**").hasRole("ADMIN")
                                // All other endpoints are accessible without authentication
                                .anyRequest().permitAll()
                )
                .httpBasic(withDefaults())
                .formLogin(formLogin -> formLogin
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .defaultSuccessUrl("/", true)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/")
                        .clearAuthentication(true)
                        .invalidateHttpSession(true)
                        .permitAll()
                )
                // Add security headers
                .headers(headers -> headers
                        .frameOptions(frameOptions -> frameOptions.sameOrigin())  // Prevent clickjacking
                        .contentSecurityPolicy(csp -> csp
                                .policyDirectives("default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'")
                        )
                        .addHeaderWriter(new StaticHeadersWriter("Permissions-Policy", "geolocation=(), microphone=(), camera=()"))
                        .addHeaderWriter(new StaticHeadersWriter("Cross-Origin-Resource-Policy", "same-origin"))
                        .xssProtection(withDefaults())
                        .contentTypeOptions(withDefaults())  // Prevent MIME type sniffing
                );
        return http.build();
    }

    @Bean
    public UserDetailsService userDetailsService() {
        UserDetails user = User.withDefaultPasswordEncoder()
                .username(username)
                .password(password)
                .roles("ADMIN")
                .build();
        return new InMemoryUserDetailsManager(user);
    }
}

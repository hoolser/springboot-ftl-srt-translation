package com.tasos.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

// Exclude DataSourceAutoConfiguration to prevent Spring Boot from trying to configure a database on start up.
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class TasosApplication {

    public static void main(String[] args) {
        SpringApplication.run(TasosApplication.class, args);
    }

}

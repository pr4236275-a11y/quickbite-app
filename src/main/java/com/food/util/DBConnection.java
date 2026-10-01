package com.food.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static String url;
    private static String username;
    private static String password;
    private static String driver;

    static {
        loadProperties();
    }

    private static void loadProperties() {
        Properties props = new Properties();
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                props.load(in);
                driver = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                url = props.getProperty("db.url", "jdbc:mysql://localhost:3306/food_ordering_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8");
                username = props.getProperty("db.username", "root");
                password = props.getProperty("db.password", "root");
            } else {
                LOGGER.warning("db.properties not found on classpath, using defaults.");
                driver = "com.mysql.cj.jdbc.Driver";
                url = "jdbc:mysql://localhost:3306/food_ordering_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
                username = "root";
                password = "root";
            }

            Class.forName(driver);
            LOGGER.info("MySQL JDBC Driver registered successfully: " + driver);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load database configuration or driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(url, username, password);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database connection error! Check MySQL status and credentials in db.properties", e);
            throw e;
        }
    }

    public static void closeQuietly(AutoCloseable resource) {
        if (resource != null) {
            try {
                resource.close();
            } catch (Exception ignored) {
            }
        }
    }
}

package com.food.dao;

import com.food.model.User;
import com.food.util.MockDatabase;

public class UserDAO {

    private final MockDatabase db = MockDatabase.getInstance();

    public User findByEmail(String email) {
        return db.getUserByEmail(email);
    }

    public User findById(int id) {
        return db.getUserById(id);
    }

    public boolean emailExists(String email) {
        return db.emailExists(email);
    }

    public boolean create(User user) {
        return db.addUser(user);
    }

    public int countAll() {
        return db.countCustomers();
    }
}

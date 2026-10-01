package com.food.dao;

import com.food.model.Category;
import com.food.util.MockDatabase;

import java.util.List;

public class CategoryDAO {

    private final MockDatabase db = MockDatabase.getInstance();

    public List<Category> findAll(boolean onlyActive) {
        return db.getAllCategories(onlyActive);
    }

    public Category findById(int id) {
        return db.getCategoryById(id);
    }

    public boolean create(Category c) {
        return db.addCategory(c);
    }

    public boolean update(Category c) {
        return db.updateCategory(c);
    }

    public boolean delete(int id) {
        return db.deleteCategory(id);
    }

    public int countAll() {
        return db.countCategories();
    }
}

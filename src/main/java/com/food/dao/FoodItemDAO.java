package com.food.dao;

import com.food.model.FoodItem;
import com.food.util.MockDatabase;

import java.util.List;

public class FoodItemDAO {

    private final MockDatabase db = MockDatabase.getInstance();

    public List<FoodItem> findAll(boolean onlyAvailable) {
        return db.getAllFoodItems(onlyAvailable);
    }

    public List<FoodItem> findByCategory(int categoryId, boolean onlyAvailable) {
        return db.getFoodItemsByCategory(categoryId, onlyAvailable);
    }

    public FoodItem findById(int id) {
        return db.getFoodItemById(id);
    }

    public List<FoodItem> search(String query, int limit) {
        return db.searchFoodItems(query, limit);
    }

    public List<FoodItem> findPopular(int limit) {
        return db.getPopularFoodItems(limit);
    }

    public boolean create(FoodItem item) {
        return db.addFoodItem(item);
    }

    public boolean update(FoodItem item) {
        return db.updateFoodItem(item);
    }

    public boolean delete(int id) {
        return db.deleteFoodItem(id);
    }

    public boolean toggleAvailability(int id, boolean available) {
        return db.toggleFoodItemAvailability(id, available);
    }

    public int countAll() {
        return db.countFoodItems();
    }
}

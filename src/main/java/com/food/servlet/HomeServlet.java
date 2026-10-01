package com.food.servlet;

import com.food.dao.CategoryDAO;
import com.food.dao.FoodItemDAO;
import com.food.model.Category;
import com.food.model.FoodItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home", "/index"})
public class HomeServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final FoodItemDAO foodItemDAO = new FoodItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Fetch categories
        List<Category> categories = categoryDAO.findAll(true);

        // 2. Fetch popular items for the top hero banner
        List<FoodItem> popularItems = foodItemDAO.findPopular(8);

        // 3. Fetch items grouped by category for horizontal carousels
        Map<Category, List<FoodItem>> categoryItemsMap = new LinkedHashMap<>();
        for (Category category : categories) {
            List<FoodItem> items = foodItemDAO.findByCategory(category.getId(), true);
            if (!items.isEmpty()) {
                categoryItemsMap.put(category, items);
            }
        }

        // Set request attributes
        request.setAttribute("categories", categories);
        request.setAttribute("popularItems", popularItems);
        request.setAttribute("categoryItemsMap", categoryItemsMap);

        // Forward to home.jsp
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}

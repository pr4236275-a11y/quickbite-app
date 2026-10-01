package com.food.servlet;

import com.food.dao.CategoryDAO;
import com.food.dao.FoodItemDAO;
import com.food.model.Category;
import com.food.model.FoodItem;
import com.food.util.JsonResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search", "/api/search"})
public class SearchServlet extends HttpServlet {

    private final FoodItemDAO foodItemDAO = new FoodItemDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        String query = request.getParameter("q");
        String categoryIdParam = request.getParameter("cat");

        // If AJAX search suggestion endpoint
        if ("/api/search".equals(path)) {
            List<FoodItem> items = foodItemDAO.search(query, 8);
            List<Map<String, Object>> results = new ArrayList<>();
            for (FoodItem item : items) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", item.getId());
                map.put("name", item.getName());
                map.put("categoryName", item.getCategoryName());
                map.put("price", item.getEffectivePrice());
                map.put("unit", item.getUnit());
                map.put("imageUrl", item.getImageUrl());
                map.put("isVeg", item.isVeg());
                results.add(map);
            }
            JsonResponse.send(response, HttpServletResponse.SC_OK, results);
            return;
        }

        // Full search page
        List<FoodItem> items;
        if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
            try {
                int catId = Integer.parseInt(categoryIdParam);
                items = foodItemDAO.findByCategory(catId, true);
                Category cat = categoryDAO.findById(catId);
                request.setAttribute("selectedCategory", cat);
            } catch (NumberFormatException e) {
                items = foodItemDAO.findAll(true);
            }
        } else if (query != null && !query.trim().isEmpty()) {
            items = foodItemDAO.search(query, 50);
        } else {
            items = foodItemDAO.findAll(true);
        }

        List<Category> categories = categoryDAO.findAll(true);
        request.setAttribute("items", items);
        request.setAttribute("categories", categories);
        request.setAttribute("searchQuery", query != null ? query : "");

        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }
}

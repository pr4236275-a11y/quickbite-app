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
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminFoodServlet", urlPatterns = {
        "/admin/items",
        "/admin/items/new",
        "/admin/items/edit",
        "/admin/items/delete",
        "/admin/items/toggle"
})
public class AdminFoodServlet extends HttpServlet {

    private final FoodItemDAO foodItemDAO = new FoodItemDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/items/new".equals(path)) {
            List<Category> categories = categoryDAO.findAll(true);
            request.setAttribute("categories", categories);
            request.setAttribute("isEdit", false);
            request.getRequestDispatcher("/admin/item-form.jsp").forward(request, response);

        } else if ("/admin/items/edit".equals(path)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                FoodItem item = foodItemDAO.findById(id);
                if (item == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/items?error=Food item not found");
                    return;
                }
                List<Category> categories = categoryDAO.findAll(false);
                request.setAttribute("item", item);
                request.setAttribute("categories", categories);
                request.setAttribute("isEdit", true);
                request.getRequestDispatcher("/admin/item-form.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/items?error=" + e.getMessage());
            }

        } else if ("/admin/items/delete".equals(path)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                foodItemDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/admin/items?success=Item deleted successfully");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/items?error=" + e.getMessage());
            }

        } else {
            // List all items
            String catParam = request.getParameter("cat");
            List<FoodItem> items;
            if (catParam != null && !catParam.isEmpty() && !"ALL".equalsIgnoreCase(catParam)) {
                try {
                    int catId = Integer.parseInt(catParam);
                    items = foodItemDAO.findByCategory(catId, false);
                } catch (NumberFormatException e) {
                    items = foodItemDAO.findAll(false);
                }
            } else {
                items = foodItemDAO.findAll(false);
            }

            List<Category> categories = categoryDAO.findAll(false);
            request.setAttribute("items", items);
            request.setAttribute("categories", categories);
            request.setAttribute("selectedCategory", catParam != null ? catParam : "ALL");

            request.getRequestDispatcher("/admin/items.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/items/toggle".equals(path)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean available = Boolean.parseBoolean(request.getParameter("available"));
                boolean updated = foodItemDAO.toggleAvailability(id, available);
                if (updated) {
                    JsonResponse.sendSuccess(response, "Item status updated", null);
                } else {
                    JsonResponse.sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Failed to toggle status");
                }
            } catch (Exception e) {
                JsonResponse.sendError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
            }
            return;
        }

        try {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String discountPriceStr = request.getParameter("discountPrice");
            BigDecimal discountPrice = (discountPriceStr != null && !discountPriceStr.trim().isEmpty())
                    ? new BigDecimal(discountPriceStr.trim()) : null;
            String unit = request.getParameter("unit");
            String imageUrl = request.getParameter("imageUrl");
            boolean isVeg = "true".equalsIgnoreCase(request.getParameter("isVeg"));
            boolean isPopular = "true".equalsIgnoreCase(request.getParameter("isPopular"));
            boolean isAvailable = "true".equalsIgnoreCase(request.getParameter("isAvailable"));
            double rating = Double.parseDouble(request.getParameter("rating") != null ? request.getParameter("rating") : "4.5");
            int deliveryTimeMins = Integer.parseInt(request.getParameter("deliveryTimeMins") != null ? request.getParameter("deliveryTimeMins") : "12");

            FoodItem item = new FoodItem();
            item.setCategoryId(categoryId);
            item.setName(name);
            item.setDescription(description);
            item.setPrice(price);
            item.setDiscountPrice(discountPrice);
            item.setUnit(unit);
            item.setImageUrl(imageUrl);
            item.setVeg(isVeg);
            item.setPopular(isPopular);
            item.setAvailable(isAvailable);
            item.setRating(rating);
            item.setDeliveryTimeMins(deliveryTimeMins);

            if ("/admin/items/edit".equals(path)) {
                int id = Integer.parseInt(request.getParameter("id"));
                item.setId(id);
                foodItemDAO.update(item);
                response.sendRedirect(request.getContextPath() + "/admin/items?success=Item updated successfully");
            } else {
                foodItemDAO.create(item);
                response.sendRedirect(request.getContextPath() + "/admin/items?success=Item created successfully");
            }

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/items?error=" + e.getMessage());
        }
    }
}

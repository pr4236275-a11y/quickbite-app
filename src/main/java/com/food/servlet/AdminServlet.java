package com.food.servlet;

import com.food.dao.CategoryDAO;
import com.food.dao.FoodItemDAO;
import com.food.dao.OrderDAO;
import com.food.dao.UserDAO;
import com.food.model.Category;
import com.food.model.Order;
import com.food.util.JsonResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin", "/admin/dashboard", "/admin/orders", "/admin/categories"})
public class AdminServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final FoodItemDAO foodItemDAO = new FoodItemDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/orders".equals(path)) {
            String status = request.getParameter("status");
            List<Order> orders = orderDAO.findAllOrders(status);
            request.setAttribute("orders", orders);
            request.setAttribute("selectedStatus", status != null ? status : "ALL");
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);

        } else if ("/admin/categories".equals(path)) {
            List<Category> categories = categoryDAO.findAll(false);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);

        } else {
            // Dashboard
            BigDecimal totalRevenue = orderDAO.getTotalRevenue();
            int totalOrders = orderDAO.getTotalOrdersCount();
            int totalItems = foodItemDAO.countAll();
            int totalCustomers = userDAO.countAll();
            List<Order> recentOrders = orderDAO.findAllOrders("ALL");
            if (recentOrders.size() > 8) {
                recentOrders = recentOrders.subList(0, 8);
            }

            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("recentOrders", recentOrders);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/orders".equals(path)) {
            handleOrderUpdate(request, response);
        } else if ("/admin/categories".equals(path)) {
            handleCategoryActions(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    private void handleOrderUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String newStatus = request.getParameter("newStatus");

                boolean updated = orderDAO.updateOrderStatus(orderId, newStatus);
                String isAjax = request.getHeader("X-Requested-With");

                if ("XMLHttpRequest".equalsIgnoreCase(isAjax)) {
                    if (updated) {
                        JsonResponse.sendSuccess(response, "Order status updated to " + newStatus, null);
                    } else {
                        JsonResponse.sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Failed to update order");
                    }
                    return;
                }

                response.sendRedirect(request.getContextPath() + "/admin/orders?success=Order #" + orderId + " updated to " + newStatus);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + e.getMessage());
            }
        }
    }

    private void handleCategoryActions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String slug = request.getParameter("slug");
                String description = request.getParameter("description");
                String imageUrl = request.getParameter("imageUrl");
                int displayOrder = Integer.parseInt(request.getParameter("displayOrder"));

                Category c = new Category();
                c.setName(name);
                c.setSlug(slug);
                c.setDescription(description);
                c.setImageUrl(imageUrl);
                c.setDisplayOrder(displayOrder);
                c.setActive(true);

                categoryDAO.create(c);
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=Category added successfully");

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String slug = request.getParameter("slug");
                String description = request.getParameter("description");
                String imageUrl = request.getParameter("imageUrl");
                int displayOrder = Integer.parseInt(request.getParameter("displayOrder"));
                boolean active = "true".equalsIgnoreCase(request.getParameter("active"));

                Category c = new Category();
                c.setId(id);
                c.setName(name);
                c.setSlug(slug);
                c.setDescription(description);
                c.setImageUrl(imageUrl);
                c.setDisplayOrder(displayOrder);
                c.setActive(active);

                categoryDAO.update(c);
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=Category updated successfully");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                categoryDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=Category deleted successfully");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=" + e.getMessage());
        }
    }
}

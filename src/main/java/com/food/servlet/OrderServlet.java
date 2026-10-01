package com.food.servlet;

import com.food.dao.OrderDAO;
import com.food.model.Order;
import com.food.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/orders", "/order-confirmation"})
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("/order-confirmation".equals(path)) {
            String orderNumber = request.getParameter("orderNumber");
            if (orderNumber == null || orderNumber.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            Order order = orderDAO.findByOrderNumber(orderNumber.trim());
            if (order == null || (order.getUserId() != user.getId() && !user.isAdmin())) {
                response.sendRedirect(request.getContextPath() + "/orders?error=Order not found");
                return;
            }

            request.setAttribute("order", order);
            request.getRequestDispatcher("/order-confirmation.jsp").forward(request, response);

        } else {
            // User order history list
            List<Order> orders = orderDAO.findByUserId(user.getId());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/orders.jsp").forward(request, response);
        }
    }
}

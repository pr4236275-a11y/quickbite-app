package com.food.dao;

import com.food.model.Order;
import com.food.model.OrderItem;
import com.food.util.MockDatabase;

import java.math.BigDecimal;
import java.util.List;

public class OrderDAO {

    private final MockDatabase db = MockDatabase.getInstance();

    public boolean createOrderWithItems(Order order, List<OrderItem> items) {
        return db.createOrder(order, items);
    }

    public Order findByOrderNumber(String orderNumber) {
        return db.getOrderByNumber(orderNumber);
    }

    public Order findById(int id) {
        return db.getOrderById(id);
    }

    public List<Order> findByUserId(int userId) {
        return db.getOrdersByUserId(userId);
    }

    public List<Order> findAllOrders(String statusFilter) {
        return db.getAllOrders(statusFilter);
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        return db.updateOrderStatus(orderId, newStatus);
    }

    public List<OrderItem> getOrderItems(int orderId) {
        return db.getOrderItems(orderId);
    }

    public BigDecimal getTotalRevenue() {
        return db.getTotalRevenue();
    }

    public int getTotalOrdersCount() {
        return db.countOrders();
    }
}

package com.food.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String STATUS_PLACED = "PLACED";
    public static final String STATUS_PREPARING = "PREPARING";
    public static final String STATUS_OUT_FOR_DELIVERY = "OUT_FOR_DELIVERY";
    public static final String STATUS_DELIVERED = "DELIVERED";
    public static final String STATUS_CANCELLED = "CANCELLED";

    private int id;
    private String orderNumber;
    private int userId;
    private Integer addressId;
    private String deliveryAddressText;
    private String customerName;
    private String customerPhone;
    private BigDecimal subtotal;
    private BigDecimal deliveryFee;
    private BigDecimal handlingFee;
    private BigDecimal totalAmount;
    private String paymentMethod; // 'COD', 'UPI'
    private String paymentStatus; // 'PENDING', 'PAID', 'FAILED'
    private String orderStatus;   // 'PLACED', 'PREPARING', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED'
    private String orderNotes;
    private int estimatedDeliveryMins;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private List<OrderItem> items = new ArrayList<>();

    public Order() {
        this.deliveryFee = BigDecimal.ZERO;
        this.handlingFee = new BigDecimal("4.00");
        this.paymentMethod = "COD";
        this.paymentStatus = "PENDING";
        this.orderStatus = STATUS_PLACED;
        this.estimatedDeliveryMins = 12;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getAddressId() {
        return addressId;
    }

    public void setAddressId(Integer addressId) {
        this.addressId = addressId;
    }

    public String getDeliveryAddressText() {
        return deliveryAddressText;
    }

    public void setDeliveryAddressText(String deliveryAddressText) {
        this.deliveryAddressText = deliveryAddressText;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public BigDecimal getDeliveryFee() {
        return deliveryFee;
    }

    public void setDeliveryFee(BigDecimal deliveryFee) {
        this.deliveryFee = deliveryFee;
    }

    public BigDecimal getHandlingFee() {
        return handlingFee;
    }

    public void setHandlingFee(BigDecimal handlingFee) {
        this.handlingFee = handlingFee;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getOrderNotes() {
        return orderNotes;
    }

    public void setOrderNotes(String orderNotes) {
        this.orderNotes = orderNotes;
    }

    public int getEstimatedDeliveryMins() {
        return estimatedDeliveryMins;
    }

    public void setEstimatedDeliveryMins(int estimatedDeliveryMins) {
        this.estimatedDeliveryMins = estimatedDeliveryMins;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public String getFormattedDate() {
        if (createdAt == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
        return sdf.format(createdAt);
    }

    public int getStatusStep() {
        if (STATUS_PLACED.equalsIgnoreCase(orderStatus)) return 1;
        if (STATUS_PREPARING.equalsIgnoreCase(orderStatus)) return 2;
        if (STATUS_OUT_FOR_DELIVERY.equalsIgnoreCase(orderStatus)) return 3;
        if (STATUS_DELIVERED.equalsIgnoreCase(orderStatus)) return 4;
        return 0; // cancelled
    }

    public String getStatusBadgeClass() {
        if (STATUS_PLACED.equalsIgnoreCase(orderStatus)) return "bg-primary";
        if (STATUS_PREPARING.equalsIgnoreCase(orderStatus)) return "bg-warning text-dark";
        if (STATUS_OUT_FOR_DELIVERY.equalsIgnoreCase(orderStatus)) return "bg-info text-dark";
        if (STATUS_DELIVERED.equalsIgnoreCase(orderStatus)) return "bg-success";
        return "bg-danger";
    }

    public String getStatusLabel() {
        if (STATUS_PLACED.equalsIgnoreCase(orderStatus)) return "Order Placed";
        if (STATUS_PREPARING.equalsIgnoreCase(orderStatus)) return "Preparing Food";
        if (STATUS_OUT_FOR_DELIVERY.equalsIgnoreCase(orderStatus)) return "Out for Delivery";
        if (STATUS_DELIVERED.equalsIgnoreCase(orderStatus)) return "Delivered";
        if (STATUS_CANCELLED.equalsIgnoreCase(orderStatus)) return "Cancelled";
        return orderStatus;
    }
}

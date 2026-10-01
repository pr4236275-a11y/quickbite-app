package com.food.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final BigDecimal FREE_DELIVERY_THRESHOLD = new BigDecimal("199.00");
    public static final BigDecimal STANDARD_DELIVERY_FEE = new BigDecimal("25.00");
    public static final BigDecimal HANDLING_FEE = new BigDecimal("4.00");

    // Key is foodItemId
    private Map<Integer, CartItem> items;

    public Cart() {
        this.items = new LinkedHashMap<>();
    }

    public synchronized void addItem(FoodItem item, int quantity) {
        if (item == null || quantity <= 0) return;
        int id = item.getId();
        if (items.containsKey(id)) {
            CartItem existing = items.get(id);
            existing.setQuantity(existing.getQuantity() + quantity);
        } else {
            items.put(id, new CartItem(item, quantity));
        }
    }

    public synchronized void updateQuantity(int foodItemId, int quantity) {
        if (quantity <= 0) {
            items.remove(foodItemId);
        } else if (items.containsKey(foodItemId)) {
            items.get(foodItemId).setQuantity(quantity);
        }
    }

    public synchronized void removeItem(int foodItemId) {
        items.remove(foodItemId);
    }

    public synchronized void clear() {
        items.clear();
    }

    public synchronized List<CartItem> getItemsList() {
        return new ArrayList<>(items.values());
    }

    public synchronized Map<Integer, CartItem> getItems() {
        return items;
    }

    public synchronized int getTotalQuantity() {
        int total = 0;
        for (CartItem ci : items.values()) {
            total += ci.getQuantity();
        }
        return total;
    }

    public synchronized int getItemCount() {
        return items.size();
    }

    public synchronized int getItemQuantity(int foodItemId) {
        CartItem ci = items.get(foodItemId);
        return ci != null ? ci.getQuantity() : 0;
    }

    public synchronized BigDecimal getSubtotal() {
        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem ci : items.values()) {
            subtotal = subtotal.add(ci.getItemTotal());
        }
        return subtotal;
    }

    public synchronized BigDecimal getDeliveryFee() {
        if (isEmpty()) return BigDecimal.ZERO;
        if (getSubtotal().compareTo(FREE_DELIVERY_THRESHOLD) >= 0) {
            return BigDecimal.ZERO;
        }
        return STANDARD_DELIVERY_FEE;
    }

    public synchronized BigDecimal getHandlingFee() {
        if (isEmpty()) return BigDecimal.ZERO;
        return HANDLING_FEE;
    }

    public synchronized BigDecimal getGrandTotal() {
        if (isEmpty()) return BigDecimal.ZERO;
        return getSubtotal().add(getDeliveryFee()).add(getHandlingFee());
    }

    public synchronized BigDecimal getAmountNeededForFreeDelivery() {
        BigDecimal sub = getSubtotal();
        if (sub.compareTo(FREE_DELIVERY_THRESHOLD) >= 0) {
            return BigDecimal.ZERO;
        }
        return FREE_DELIVERY_THRESHOLD.subtract(sub);
    }

    public synchronized boolean isFreeDeliveryEligible() {
        return !isEmpty() && getSubtotal().compareTo(FREE_DELIVERY_THRESHOLD) >= 0;
    }

    public synchronized boolean isEmpty() {
        return items.isEmpty();
    }
}

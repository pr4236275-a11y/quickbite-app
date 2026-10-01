package com.food.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;

public class FoodItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int categoryId;
    private String categoryName;
    private String name;
    private String description;
    private BigDecimal price;
    private BigDecimal discountPrice;
    private String unit;
    private String imageUrl;
    private boolean veg;
    private boolean popular;
    private boolean available;
    private double rating;
    private int deliveryTimeMins;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public FoodItem() {
        this.veg = true;
        this.available = true;
        this.rating = 4.5;
        this.deliveryTimeMins = 12;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(BigDecimal discountPrice) {
        this.discountPrice = discountPrice;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isVeg() {
        return veg;
    }

    public void setVeg(boolean veg) {
        this.veg = veg;
    }

    public boolean isPopular() {
        return popular;
    }

    public void setPopular(boolean popular) {
        this.popular = popular;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getDeliveryTimeMins() {
        return deliveryTimeMins;
    }

    public void setDeliveryTimeMins(int deliveryTimeMins) {
        this.deliveryTimeMins = deliveryTimeMins;
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

    // Business helper methods
    public BigDecimal getEffectivePrice() {
        if (discountPrice != null && discountPrice.compareTo(BigDecimal.ZERO) > 0 && discountPrice.compareTo(price) < 0) {
            return discountPrice;
        }
        return price;
    }

    public boolean hasDiscount() {
        return discountPrice != null && discountPrice.compareTo(BigDecimal.ZERO) > 0 && discountPrice.compareTo(price) < 0;
    }

    public int getDiscountPercentage() {
        if (!hasDiscount() || price == null || price.compareTo(BigDecimal.ZERO) <= 0) {
            return 0;
        }
        BigDecimal diff = price.subtract(discountPrice);
        BigDecimal pct = diff.divide(price, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100));
        return pct.setScale(0, RoundingMode.HALF_UP).intValue();
    }
}

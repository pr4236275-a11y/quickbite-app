package com.food.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Address implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String addressType; // 'Home', 'Work', 'Other'
    private String addressLine1;
    private String addressLine2;
    private String landmark;
    private String city;
    private String state;
    private String pincode;
    private boolean isDefault;
    private Timestamp createdAt;

    public Address() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAddressType() {
        return addressType;
    }

    public void setAddressType(String addressType) {
        this.addressType = addressType;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public String getLandmark() {
        return landmark;
    }

    public void setLandmark(String landmark) {
        this.landmark = landmark;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPincode() {
        return pincode;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getFormattedAddress() {
        StringBuilder sb = new StringBuilder();
        if (addressLine1 != null && !addressLine1.trim().isEmpty()) sb.append(addressLine1);
        if (addressLine2 != null && !addressLine2.trim().isEmpty()) sb.append(", ").append(addressLine2);
        if (landmark != null && !landmark.trim().isEmpty()) sb.append(" (Near ").append(landmark).append(")");
        if (city != null && !city.trim().isEmpty()) sb.append(", ").append(city);
        if (state != null && !state.trim().isEmpty()) sb.append(", ").append(state);
        if (pincode != null && !pincode.trim().isEmpty()) sb.append(" - ").append(pincode);
        return sb.toString();
    }
}

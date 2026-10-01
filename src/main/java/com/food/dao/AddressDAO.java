package com.food.dao;

import com.food.model.Address;
import com.food.util.MockDatabase;

import java.util.List;

public class AddressDAO {

    private final MockDatabase db = MockDatabase.getInstance();

    public List<Address> findByUserId(int userId) {
        return db.getAddressesByUserId(userId);
    }

    public Address findDefaultByUserId(int userId) {
        return db.getDefaultAddressByUserId(userId);
    }

    public Address findById(int id) {
        return db.getAddressById(id);
    }

    public boolean create(Address address) {
        return db.addAddress(address);
    }

    public boolean setDefault(int addressId, int userId) {
        return db.setDefaultAddress(addressId, userId);
    }
}

package com.food.servlet;

import com.food.dao.AddressDAO;
import com.food.dao.OrderDAO;
import com.food.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private final AddressDAO addressDAO = new AddressDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        Cart cart = (session != null) ? (Cart) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home?info=Your cart is empty. Add some delicious items first!");
            return;
        }

        List<Address> addresses = addressDAO.findByUserId(user.getId());
        Address defaultAddress = addressDAO.findDefaultByUserId(user.getId());

        request.setAttribute("addresses", addresses);
        request.setAttribute("defaultAddress", defaultAddress);
        request.setAttribute("cart", cart);

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        Cart cart = (session != null) ? (Cart) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home?error=Cannot checkout an empty cart");
            return;
        }

        String addressChoice = request.getParameter("addressChoice"); // 'existing' or 'new'
        String selectedAddressIdStr = request.getParameter("selectedAddressId");
        String paymentMethod = request.getParameter("paymentMethod"); // 'COD' or 'UPI'
        String orderNotes = request.getParameter("orderNotes");
        String phone = request.getParameter("phone");

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "COD";
        }

        String deliveryAddressText = "";
        Integer addressId = null;

        if ("existing".equals(addressChoice) && selectedAddressIdStr != null && !selectedAddressIdStr.isEmpty()) {
            try {
                int aId = Integer.parseInt(selectedAddressIdStr);
                Address addr = addressDAO.findById(aId);
                if (addr != null && addr.getUserId() == user.getId()) {
                    addressId = addr.getId();
                    deliveryAddressText = addr.getFormattedAddress();
                }
            } catch (NumberFormatException ignored) {}
        }

        // If new address entered or existing address was invalid
        if (deliveryAddressText.isEmpty()) {
            String addressLine1 = request.getParameter("addressLine1");
            String addressLine2 = request.getParameter("addressLine2");
            String landmark = request.getParameter("landmark");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String pincode = request.getParameter("pincode");
            String addressType = request.getParameter("addressType");
            boolean saveAsDefault = "true".equalsIgnoreCase(request.getParameter("saveAsDefault"));

            if (addressLine1 == null || addressLine1.trim().isEmpty() ||
                city == null || city.trim().isEmpty() ||
                pincode == null || pincode.trim().isEmpty()) {
                request.setAttribute("error", "Please provide a valid delivery address.");
                doGet(request, response);
                return;
            }

            Address newAddr = new Address();
            newAddr.setUserId(user.getId());
            newAddr.setAddressType(addressType != null ? addressType : "Home");
            newAddr.setAddressLine1(addressLine1.trim());
            newAddr.setAddressLine2(addressLine2 != null ? addressLine2.trim() : "");
            newAddr.setLandmark(landmark != null ? landmark.trim() : "");
            newAddr.setCity(city.trim());
            newAddr.setState(state != null && !state.trim().isEmpty() ? state.trim() : "Karnataka");
            newAddr.setPincode(pincode.trim());
            newAddr.setDefault(saveAsDefault);

            if (addressDAO.create(newAddr)) {
                addressId = newAddr.getId();
                deliveryAddressText = newAddr.getFormattedAddress();
            } else {
                deliveryAddressText = addressLine1 + ", " + city + " - " + pincode;
            }
        }

        // Generate Order
        String orderNumber = generateOrderNumber();
        Order order = new Order();
        order.setOrderNumber(orderNumber);
        order.setUserId(user.getId());
        order.setAddressId(addressId);
        order.setDeliveryAddressText(deliveryAddressText);
        order.setCustomerName(user.getName());
        order.setCustomerPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : user.getPhone());
        order.setSubtotal(cart.getSubtotal());
        order.setDeliveryFee(cart.getDeliveryFee());
        order.setHandlingFee(cart.getHandlingFee());
        order.setTotalAmount(cart.getGrandTotal());
        order.setPaymentMethod(paymentMethod.toUpperCase());
        order.setPaymentStatus("UPI".equalsIgnoreCase(paymentMethod) ? "PAID" : "PENDING");
        order.setOrderStatus(Order.STATUS_PLACED);
        order.setOrderNotes(orderNotes != null ? orderNotes.trim() : "");
        order.setEstimatedDeliveryMins(12);

        // Build line items
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem ci : cart.getItemsList()) {
            OrderItem oi = new OrderItem();
            oi.setFoodItemId(ci.getFoodItem().getId());
            oi.setItemName(ci.getFoodItem().getName());
            oi.setPrice(ci.getFoodItem().getEffectivePrice());
            oi.setQuantity(ci.getQuantity());
            oi.setTotalPrice(ci.getItemTotal());
            orderItems.add(oi);
        }

        boolean success = orderDAO.createOrderWithItems(order, orderItems);
        if (success) {
            // Clear cart
            cart.clear();
            session.setAttribute("cart", cart);
            response.sendRedirect(request.getContextPath() + "/order-confirmation?orderNumber=" + orderNumber);
        } else {
            request.setAttribute("error", "Failed to place your order. Please try again.");
            doGet(request, response);
        }
    }

    private String generateOrderNumber() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(new Date());
        int randomNum = 1000 + new Random().nextInt(9000);
        return "BLK-" + dateStr + "-" + randomNum;
    }
}

package com.food.servlet;

import com.food.dao.FoodItemDAO;
import com.food.model.Cart;
import com.food.model.CartItem;
import com.food.model.FoodItem;
import com.food.util.JsonResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart", "/api/cart"})
public class CartServlet extends HttpServlet {

    private final FoodItemDAO foodItemDAO = new FoodItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cart cart = getOrCreateCart(request);
        JsonResponse.send(response, HttpServletResponse.SC_OK, buildCartResponseData(cart));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "get";
        }

        Cart cart = getOrCreateCart(request);

        try {
            switch (action) {
                case "add": {
                    int foodId = Integer.parseInt(request.getParameter("foodId"));
                    int qty = 1;
                    if (request.getParameter("qty") != null) {
                        qty = Integer.parseInt(request.getParameter("qty"));
                    }

                    FoodItem foodItem = foodItemDAO.findById(foodId);
                    if (foodItem == null || !foodItem.isAvailable()) {
                        JsonResponse.sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Item is unavailable");
                        return;
                    }

                    cart.addItem(foodItem, qty);
                    break;
                }
                case "update": {
                    int foodId = Integer.parseInt(request.getParameter("foodId"));
                    int qty = Integer.parseInt(request.getParameter("qty"));
                    cart.updateQuantity(foodId, qty);
                    break;
                }
                case "remove": {
                    int foodId = Integer.parseInt(request.getParameter("foodId"));
                    cart.removeItem(foodId);
                    break;
                }
                case "clear": {
                    cart.clear();
                    break;
                }
                case "get":
                default:
                    // Return current state
                    break;
            }

            Map<String, Object> data = buildCartResponseData(cart);
            JsonResponse.sendSuccess(response, "Cart updated successfully", data);

        } catch (NumberFormatException e) {
            JsonResponse.sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid item or quantity parameter");
        } catch (Exception e) {
            JsonResponse.sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating cart: " + e.getMessage());
        }
    }

    private Cart getOrCreateCart(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private Map<String, Object> buildCartResponseData(Cart cart) {
        Map<String, Object> data = new HashMap<>();

        List<Map<String, Object>> itemsList = new ArrayList<>();
        for (CartItem ci : cart.getItemsList()) {
            FoodItem fi = ci.getFoodItem();
            Map<String, Object> itemMap = new HashMap<>();
            itemMap.put("id", fi.getId());
            itemMap.put("name", fi.getName());
            itemMap.put("unit", fi.getUnit());
            itemMap.put("imageUrl", fi.getImageUrl());
            itemMap.put("price", fi.getPrice());
            itemMap.put("discountPrice", fi.getDiscountPrice());
            itemMap.put("effectivePrice", fi.getEffectivePrice());
            itemMap.put("isVeg", fi.isVeg());
            itemMap.put("quantity", ci.getQuantity());
            itemMap.put("itemTotal", ci.getItemTotal());
            itemsList.add(itemMap);
        }

        data.put("items", itemsList);
        data.put("totalQuantity", cart.getTotalQuantity());
        data.put("itemCount", cart.getItemCount());
        data.put("subtotal", cart.getSubtotal());
        data.put("deliveryFee", cart.getDeliveryFee());
        data.put("handlingFee", cart.getHandlingFee());
        data.put("grandTotal", cart.getGrandTotal());
        data.put("freeDeliveryThreshold", Cart.FREE_DELIVERY_THRESHOLD);
        data.put("isFreeDeliveryEligible", cart.isFreeDeliveryEligible());
        data.put("amountNeededForFreeDelivery", cart.getAmountNeededForFreeDelivery());
        data.put("isEmpty", cart.isEmpty());

        return data;
    }
}

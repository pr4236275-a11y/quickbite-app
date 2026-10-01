package com.food.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

public class JsonResponse {
    private static final Gson GSON = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .serializeNulls()
            .create();

    public static void send(HttpServletResponse response, int status, Object data) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(GSON.toJson(data));
            out.flush();
        }
    }

    public static void sendSuccess(HttpServletResponse response, String message, Object payload) throws IOException {
        Map<String, Object> map = new HashMap<>();
        map.put("success", true);
        map.put("message", message);
        if (payload != null) {
            map.put("data", payload);
        }
        send(response, HttpServletResponse.SC_OK, map);
    }

    public static void sendError(HttpServletResponse response, int status, String message) throws IOException {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        map.put("message", message);
        send(response, status, map);
    }
}

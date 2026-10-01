package com.food.filter;

import com.food.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/checkout", "/orders", "/order-confirmation"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            String targetUri = req.getRequestURI();
            String query = req.getQueryString();
            if (query != null && !query.isEmpty()) {
                targetUri += "?" + query;
            }
            if (session == null) {
                session = req.getSession(true);
            }
            session.setAttribute("redirectAfterLogin", targetUri);
            res.sendRedirect(req.getContextPath() + "/login?error=Please login to continue");
            return;
        }

        chain.doFilter(req, res);
    }
}

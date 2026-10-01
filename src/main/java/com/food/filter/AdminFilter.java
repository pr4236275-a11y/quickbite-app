package com.food.filter;

import com.food.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            session = req.getSession(true);
            session.setAttribute("redirectAfterLogin", req.getRequestURI());
            res.sendRedirect(req.getContextPath() + "/login?error=Admin login required");
            return;
        }

        if (!user.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/home?error=Access denied: Admin privileges required");
            return;
        }

        chain.doFilter(req, res);
    }
}

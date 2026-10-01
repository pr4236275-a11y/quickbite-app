package com.food.servlet;

import com.food.dao.UserDAO;
import com.food.model.User;
import com.food.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("user");
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/home?info=You have been logged out");
            return;
        }

        // If user already logged in, redirect home
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if ("/register".equals(path)) {
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/register".equals(path)) {
            handleRegister(request, response);
        } else if ("/login".equals(path)) {
            handleLogin(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findByEmail(email.trim());
        if (user == null || !PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Valid user -> create session
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);

        String redirect = (String) session.getAttribute("redirectAfterLogin");
        if (redirect != null && !redirect.isEmpty()) {
            session.removeAttribute("redirectAfterLogin");
            response.sendRedirect(redirect);
        } else if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/home?success=Welcome back, " + user.getName());
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all mandatory fields.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.emailExists(email.trim())) {
            request.setAttribute("error", "An account with this email already exists.");
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create new customer
        User newUser = new User();
        newUser.setName(name.trim());
        newUser.setEmail(email.trim().toLowerCase());
        newUser.setPhone(phone != null ? phone.trim() : "");
        newUser.setPasswordHash(PasswordUtil.hashPassword(password));
        newUser.setRole("CUSTOMER");

        boolean created = userDAO.create(newUser);
        if (created) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", newUser);

            String redirect = (String) session.getAttribute("redirectAfterLogin");
            if (redirect != null && !redirect.isEmpty()) {
                session.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/home?success=Account created successfully!");
            }
        } else {
            request.setAttribute("error", "Failed to create account due to server error.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}

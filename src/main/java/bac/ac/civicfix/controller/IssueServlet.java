package bac.ac.civicfix.controller;

import bac.ac.civicfix.dao.CategoryDAO;
import bac.ac.civicfix.dao.IssueDAO;
import bac.ac.civicfix.model.Category;
import bac.ac.civicfix.model.Issue;
import bac.ac.civicfix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/dashboard", "/report-issue", "/update-status"})
public class IssueServlet extends HttpServlet {

    private final IssueDAO issueDAO = new IssueDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        if ("/report-issue".equals(action)) {
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/WEB-INF/views/report-issue.jsp").forward(request, response);
        } else {
            // Default: Dashboard feed
            List<Issue> issues = issueDAO.getAllIssues();
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("issues", issues);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        if ("/report-issue".equals(action)) {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            long categoryId = Long.parseLong(request.getParameter("categoryId"));

            Issue issue = new Issue();
            issue.setTitle(title);
            issue.setDescription(description);
            issue.setCategoryId(categoryId);
            issue.setCitizenId(user.getId());
            issue.setStatus("SUBMITTED");

            boolean success = issueDAO.createIssue(issue);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("errorMessage", "Failed to submit issue report.");
                doGet(request, response);
            }
        } else if ("/update-status".equals(action)) {
            // Role enforcement check
            if (!"OFFICIAL".equals(user.getRole())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Officials only.");
                return;
            }

            long issueId = Long.parseLong(request.getParameter("issueId"));
            String newStatus = request.getParameter("status");

            issueDAO.updateIssueStatus(issueId, newStatus);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}
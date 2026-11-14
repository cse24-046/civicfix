Here is the correct, practical version for this CivicFix project:
1.This project is a local academic/AWD practical project, not a production-ready system.

2.Database connection details are hardcoded in:    src/main/java/bac/ac/civicfix/util/DBConnection.java
   JDBC URL:    jdbc:mysql://localhost:3306/civicfix_db?useSSL=false&serverTimezone=UTC
   USER:    root
   PASSWORD:    bianca.1865

3.The app uses role-based access control:    • CITIZEN users can register and report issues    • OFFICIAL users can access the dashboard and update issue statuses

4.The RoleFilter restricts access to protected routes like /dashboard, /report-issue, and /update-status.

5.The app stores the logged-in user in the session as currentUser.

6.If the app is run in a fresh environment, create the MySQL database and tables first.

7.Note: the app expects categories and users to exist before testing issue submission.

PROJECT STRUCTURE src/main/java/bac/ac/civicfix/  
controller/     AuthServlet.java     IssueServlet.java   
dao/     UserDAO.java     IssueDAO.java     CategoryDAO.java  
filter/     RoleFilter.java   
model/     User.java     Issue.java     Category.java   
util/     DBConnection.java
src/main/webapp/   index.jsp   WEB-INF/views/     login.jsp     report-issue.jsp     dashboard.jsp

FEATURES
1.Citizen Login and Registration    
• Login and registration are handled in AuthServlet.    
• The same page contains both the login form and the citizen registration form.  
• After a successful login, the user is stored in the session.

2.Issue Reporting   
• Citizen users can submit issue reports.  
• The app takes title, description, and category selection.   
• Reports are inserted into the issues table.

3.Dashboard Feed    
• Officials and citizens can view submitted issues.
• Issues are listed in descending order of created date.  
• The dashboard shows title, description, status, and date reported.

4.Official Status Updates
• Only OFFICIAL users can change issue status.  
• Status values include SUBMITTED, IN_PROGRESS, and RESOLVED.

5.Role Security  
• RoleFilter prevents unauthorized access.   
• Users without a valid session are redirected to login.   
• Officials-only actions are blocked for citizens.

CORE CODE SNIPPETS
1)Database connection

package bac.ac.civicfix.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/civicfix_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "bianca.1865";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

2)User lookup in DAO

public User findByEmail(String email) {
    String sql = "SELECT id, email, password, full_name, role FROM users WHERE email = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, email);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new User(
                        rs.getLong("id"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getString("role")
                );
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
3)Registration logic

public boolean registerUser(User user) {
    String sql = "INSERT INTO users (email, password, full_name, role) VALUES (?, ?, ?, ?)";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, user.getEmail());
        ps.setString(2, user.getPassword());
        ps.setString(3, user.getFullName());
        ps.setString(4, user.getRole());

        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

4)Login logic

if ("/login".equals(action)) {
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    User user = userDAO.findByEmail(email);

    if (user != null && user.getPassword().equals(password)) {
        HttpSession session = request.getSession();
        session.setAttribute("currentUser", user);
        response.sendRedirect(request.getContextPath() + "/dashboard");
    } else {
        request.setAttribute("errorMessage", "Invalid email or password.");
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
}

5)Reporting issue

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
}

6)Update issue status by officials
else if ("/update-status".equals(action)) {
    if (!"OFFICIAL".equals(user.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Officials only.");
        return;
    }

    long issueId = Long.parseLong(request.getParameter("issueId"));
    String newStatus = request.getParameter("status");

    issueDAO.updateIssueStatus(issueId, newStatus);
    response.sendRedirect(request.getContextPath() + "/dashboard");
}

7)Role filter

@WebFilter(urlPatterns = {"/dashboard", "/report-issue", "/update-status"})
public class RoleFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("currentUser") != null);

        if (!isLoggedIn) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=unauthorized");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        String path = httpRequest.getRequestURI();

        if (path.contains("update-status") && !"OFFICIAL".equals(user.getRole())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Only municipal officials can update issue statuses.");
            return;
        }

        chain.doFilter(request, response);
    }
}

SQL QUERIES USED IN THE DATABASE
1.Create users table
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'CITIZEN'
);

2.Create categories table
CREATE TABLE categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

3.Create issues table
CREATE TABLE issues (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category_id BIGINT NOT NULL,
    citizen_id BIGINT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'SUBMITTED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (citizen_id) REFERENCES users(id)
);

4.Login query
SELECT id, email, password, full_name, role
FROM users
WHERE email = ?;

5.
Register new citizen
INSERT INTO users (email, password, full_name, role)
VALUES (?, ?, ?, ?);

7.
Get all categories
SELECT id, name, description
FROM categories;

9.
Create new issue report
INSERT INTO issues (title, description, category_id, citizen_id, status)
VALUES (?, ?, ?, ?, ?);

11.
View all issues newest first
SELECT id, title, description, category_id, citizen_id, status, created_at
FROM issues
ORDER BY created_at DESC;

13.
Update issue status
UPDATE issues
SET status = ?
WHERE id = ?;

15.
Insert sample categories
INSERT INTO categories (name, description) VALUES
('Roads', 'Potholes, damaged roads, traffic issues'),
('Water', 'Leaking pipes, low water pressure, contamination'),
('Electricity', 'Broken streetlights, outages, unsafe wiring'),
('Sanitation', 'Garbage overflow, clogged drains, sewage issues');

16.
Sample citizen
INSERT INTO users (email, password, full_name, role)
VALUES ('citizen@example.com', 'citizen123', 'Jane Citizen', 'CITIZEN');

17.
Sample official
INSERT INTO users (email, password, full_name, role)
VALUES ('official@civicfix.com', 'official123', 'Municipal Officer', 'OFFICIAL');
18.
Sample issue
INSERT INTO issues (title, description, category_id, citizen_id, status)
VALUES ('Large pothole on Main Street', 'Deep pothole near the bus stop causing traffic risk', 1, 2, 'SUBMITTED');

package bac.ac.civicfix.dao;

import bac.ac.civicfix.model.Issue;
import bac.ac.civicfix.util.DBConnection;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class IssueDAO {

    public boolean createIssue(Issue issue) {
        String sql = "INSERT INTO issues (title, description, category_id, citizen_id, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, issue.getTitle());
            ps.setString(2, issue.getDescription());
            ps.setLong(3, issue.getCategoryId());
            ps.setLong(4, issue.getCitizenId());
            ps.setString(5, issue.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Issue> getAllIssues() {
        List<Issue> issues = new ArrayList<>();
        String sql = "SELECT id, title, description, category_id, citizen_id, status, created_at FROM issues ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Timestamp timestamp = rs.getTimestamp("created_at");
                LocalDateTime createdAt = timestamp != null ? timestamp.toLocalDateTime() : null;

                Issue issue = new Issue(
                        rs.getLong("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getLong("category_id"),
                        rs.getLong("citizen_id"),
                        rs.getString("status"),
                        createdAt
                );
                issues.add(issue);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return issues;
    }

    public boolean updateIssueStatus(long issueId, String newStatus) {
        String sql = "UPDATE issues SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setLong(2, issueId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
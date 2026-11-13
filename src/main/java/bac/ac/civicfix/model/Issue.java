package bac.ac.civicfix.model;

import java.time.LocalDateTime;

public class Issue {
    private long id;
    private String title;
    private String description;
    private long categoryId;
    private long citizenId;
    private String status; // "SUBMITTED", "IN_PROGRESS", "RESOLVED"
    private LocalDateTime createdAt;

    public Issue() {}

    public Issue(long id, String title, String description, long categoryId, long citizenId, String status, LocalDateTime createdAt) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.categoryId = categoryId;
        this.citizenId = citizenId;
        this.status = status;
        this.createdAt = createdAt;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public long getCategoryId() { return categoryId; }
    public void setCategoryId(long categoryId) { this.categoryId = categoryId; }

    public long getCitizenId() { return citizenId; }
    public void setCitizenId(long citizenId) { this.citizenId = citizenId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CivicFix - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand fw-bold">CivicFix Issue Tracker</span>
        <div class="d-flex align-items-center text-white">
                <span class="me-3">
                    <strong>${sessionScope.currentUser.fullName}</strong>
                    <span class="badge bg-secondary ms-1">${sessionScope.currentUser.role}</span>
                </span>
            <form action="${pageContext.request.contextPath}/logout" method="get" class="m-0">
                <button type="submit" class="btn btn-outline-light btn-sm">Logout</button>
            </form>
        </div>
    </div>
</nav>

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold m-0">Reported Municipal Issues</h3>
        <c:if test="${sessionScope.currentUser.role eq 'CITIZEN'}">
            <form action="${pageContext.request.contextPath}/report-issue" method="get" class="m-0">
                <button type="submit" class="btn btn-primary">+ Report New Issue</button>
            </form>
        </c:if>
    </div>

    <div class="card shadow-sm border-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>Date Reported</th>
                    <c:if test="${sessionScope.currentUser.role eq 'OFFICIAL'}">
                        <th>Action</th>
                    </c:if>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="issue" items="${issues}">
                    <tr>
                        <td>${issue.id}</td>
                        <td class="fw-semibold">${issue.title}</td>
                        <td>${issue.description}</td>
                        <td>
                            <c:choose>
                                <c:when test="${issue.status eq 'SUBMITTED'}">
                                    <span class="badge bg-warning text-dark">SUBMITTED</span>
                                </c:when>
                                <c:when test="${issue.status eq 'IN_PROGRESS'}">
                                    <span class="badge bg-info text-dark">IN_PROGRESS</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-success">RESOLVED</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-muted small">${issue.createdAt}</td>
                        <c:if test="${sessionScope.currentUser.role eq 'OFFICIAL'}">
                            <td>
                                <form action="${pageContext.request.contextPath}/update-status" method="post" class="d-flex gap-2">
                                    <input type="hidden" name="issueId" value="${issue.id}">
                                    <select name="status" class="form-select form-select-sm w-auto">
                                        <option value="SUBMITTED" ${issue.status == 'SUBMITTED' ? 'selected' : ''}>SUBMITTED</option>
                                        <option value="IN_PROGRESS" ${issue.status == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                                        <option value="RESOLVED" ${issue.status == 'RESOLVED' ? 'selected' : ''}>RESOLVED</option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-primary">Update</button>
                                </form>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
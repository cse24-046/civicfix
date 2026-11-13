<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Report Issue - CivicFix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light py-5">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card shadow-sm border-0 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="fw-bold m-0">Report Municipal Issue</h3>
                    <form action="${pageContext.request.contextPath}/dashboard" method="get" class="m-0">
                        <button type="submit" class="btn btn-outline-secondary btn-sm">&larr; Back</button>
                    </form>
                </div>

                <form action="${pageContext.request.contextPath}/report-issue" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Issue Title</label>
                        <input type="text" name="title" class="form-control" placeholder="e.g., Large pothole on Main Street" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category</label>
                        <select name="categoryId" class="form-select">
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}">${cat.name} - ${cat.description}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Description & Location Details</label>
                        <textarea name="description" rows="4" class="form-control" placeholder="Provide exact location landmarks and details..." required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Submit Report</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
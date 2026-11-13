<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CivicFix - Municipal Issue Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center min-vh-100">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card shadow-sm border-0 p-4 text-center">
                <div class="card-body">
                    <h1 class="fw-bold text-dark mb-3">CivicFix Portal</h1>
                    <p class="text-muted mb-4">
                        Empowering citizens and municipal officials to report, track, and resolve local community infrastructure issues efficiently.
                    </p>
                    <form action="${pageContext.request.contextPath}/login" method="get">
                        <button type="submit" class="btn btn-primary btn-lg px-4">
                            Get Started / Login
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
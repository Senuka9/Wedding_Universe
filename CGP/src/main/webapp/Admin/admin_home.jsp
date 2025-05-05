<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard – Dream Weddings</title>
        <link rel="stylesheet" href="../css/styles.css">
        <style>
            :root {
                --primary-color: #5D1D88;
                --primary-light: #7E2EBB;
                --primary-dark: #4A1769;
                --accent-color: #F6D2E0;
                --accent-light: #FBE9F0;
                --accent-dark: #E9A5C3;
                --text-dark: #333333;
                --text-light: #FFFFFF;
                --background-light: #F8F5FC;
                --background-dark: #1A0D26;
                --success-color: #34D399;
                --warning-color: #FBBF24;
                --error-color: #EF4444;
                --card-shadow: 0 8px 24px rgba(93, 29, 136, 0.1);
                --card-shadow-hover: 0 12px 32px rgba(93, 29, 136, 0.18);
            }

            body {
                font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
                color: var(--text-dark);
                background-color: var(--background-light);
                margin: 0;
                padding: 0;
                line-height: 1.5;
            }

            .admin-dashboard {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .dashboard-header {
                background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
                color: var(--text-light);
                padding: 1.5rem;
                position: relative;
                overflow: hidden;
            }

            .dashboard-header::before, .dashboard-header::after {
                content: '';
                position: absolute;
                width: 300px;
                height: 300px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.05);
                z-index: 0;
            }

            .dashboard-header::before {
                top: -150px;
                left: -100px;
            }

            .dashboard-header::after {
                bottom: -150px;
                right: -100px;
            }

            .header-content {
                position: relative;
                z-index: 1;
                text-align: center;
                max-width: 1200px;
                margin: 0 auto;
            }

            .dashboard-header h1 {
                margin: 0;
                font-size: 2.5rem;
                font-weight: 700;
                letter-spacing: -0.5px;
            }

            .dashboard-header p {
                margin: 0.5rem 0 0;
                font-size: 1.125rem;
                opacity: 0.9;
            }

            .dashboard-container {
                max-width: 1200px;
                width: 100%;
                margin: 0 auto;
                padding: 2rem 1rem;
                flex: 1;
            }

            .welcome-section {
                text-align: center;
                margin-bottom: 3rem;
            }

            .welcome-section h2 {
                font-size: 2rem;
                color: var(--primary-color);
                margin: 0 0 0.5rem;
                font-weight: 600;
            }

            .welcome-section p {
                font-size: 1.125rem;
                color: var(--text-dark);
                opacity: 0.8;
                margin: 0;
            }

            .dashboard-cards {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 2rem;
            }

            .card {
                background: #fff;
                border-radius: 16px;
                padding: 2rem;
                box-shadow: var(--card-shadow);
                transition: all 0.3s ease;
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 4px;
                background: var(--primary-color);
                transform: scaleX(0);
                transform-origin: left;
                transition: transform 0.3s ease;
            }

            .card:hover {
                transform: translateY(-8px);
                box-shadow: var(--card-shadow-hover);
            }

            .card:hover::before {
                transform: scaleX(1);
            }

            .card-icon {
                background-color: var(--accent-light);
                color: var(--primary-color);
                width: 72px;
                height: 72px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 1.5rem;
                transition: all 0.3s ease;
            }

            .card:hover .card-icon {
                background-color: var(--primary-color);
                color: var(--text-light);
                transform: scale(1.05);
            }

            .card h3 {
                margin: 0 0 0.75rem;
                font-size: 1.5rem;
                font-weight: 600;
                color: var(--primary-color);
            }

            .card p {
                margin: 0 0 1.5rem;
                font-size: 1rem;
                color: var(--text-dark);
                opacity: 0.7;
                line-height: 1.5;
            }

            .card-button {
                display: inline-block;
                padding: 0.75rem 1.5rem;
                background-color: var(--primary-color);
                color: var(--text-light);
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.2s ease;
                margin-top: auto;
                border: 2px solid var(--primary-color);
            }

            .card-button:hover {
                background-color: var(--primary-light);
                transform: translateY(-2px);
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .dashboard-header h1 {
                    font-size: 2rem;
                }

                .welcome-section h2 {
                    font-size: 1.75rem;
                }

                .dashboard-cards {
                    grid-template-columns: 1fr;
                }

                .card {
                    padding: 1.5rem;
                }
            }

            @media (min-width: 769px) and (max-width: 1024px) {
                .dashboard-cards {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            /* Animation keyframes */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .welcome-section, .card {
                animation: fadeIn 0.5s ease-out forwards;
            }

            .card:nth-child(1) {
                animation-delay: 0.1s;
            }

            .card:nth-child(2) {
                animation-delay: 0.2s;
            }

            .card:nth-child(3) {
                animation-delay: 0.3s;
            }
        </style>
    </head>
    <body>

        <div class="dashboard-container">
            <div class="dashboard-header">
                <h1>Welcome Admin</h1>
            </div><br>

            <div class="dashboard-cards">
                <!-- Manage Users -->
                <div class="card">
                    <h3>Manage Users</h3>
                    <a href="manage_users.jsp">Go to Users</a>
                </div>

                <!-- Manage Bookings -->
                <div class="card">
                    <h3>Manage Bookings</h3>
                    <a href="manage_bookings.jsp?service=attire">Go to Bookings</a>
                </div>

                <!-- Manage Services -->
                <div class="card">
                    <h3>Manage Services</h3>
                    <a href="manage_services.jsp?service=cake">Go to Services</a>
                </div>

            </div>
        </div>

    </body>
</html>

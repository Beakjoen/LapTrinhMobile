# API Documentation - Web API Exam 05

Student ID: 1771020358
Database Name: db_exam_1771020358

## Authentication

### Register
- **Endpoint**: `POST /api/auth/register`
- **Body**:
  ```json
  {
    "email": "customer@example.com",
    "password": "password123",
    "full_name": "Nguyen Van A",
    "phone_number": "0123456789",
    "address": "123 Street"
  }
  ```

### Login
- **Endpoint**: `POST /api/auth/login`
- **Body**:
  ```json
  {
    "email": "customer@example.com",
    "password": "password123"
  }
  ```
- **Response**: Includes `token`, `user`, and `student_id`.

### Get Current User
- **Endpoint**: `GET /api/auth/me`
- **Headers**: `Authorization: Bearer <token>`

## Customer Management

### Get All Customers (Admin only)
- **Endpoint**: `GET /api/customers`

### Get Customer by ID
- **Endpoint**: `GET /api/customers/:id`

### Update Customer
- **Endpoint**: `PUT /api/customers/:id`
- **Body**: `full_name`, `phone_number`, `address`

### Get Customer Reservations
- **Endpoint**: `GET /api/customers/:id/reservations`

## Menu Management

### Get Menu Items
- **Endpoint**: `GET /api/menu-items`
- **Query Params**: `page`, `limit`, `search`, `category`, `vegetarian_only`, `spicy_only`, `available_only`

### Get Menu Item by ID
- **Endpoint**: `GET /api/menu-items/:id`

### Create Menu Item (Admin only)
- **Endpoint**: `POST /api/menu-items`

### Update Menu Item (Admin only)
- **Endpoint**: `PUT /api/menu-items/:id`

### Delete Menu Item (Admin only)
- **Endpoint**: `DELETE /api/menu-items/:id`

### Search Menu Items
- **Endpoint**: `GET /api/menu-items/search?q=keyword`

## Reservation Management

### Create Reservation
- **Endpoint**: `POST /api/reservations`
- **Body**:
  ```json
  {
    "reservation_date": "2024-01-15T19:00:00Z",
    "number_of_guests": 4,
    "special_requests": "Window seat"
  }
  ```

### Add Items to Reservation
- **Endpoint**: `POST /api/reservations/:id/items`
- **Body**:
  ```json
  {
    "menu_item_id": 1,
    "quantity": 2
  }
  ```

### Confirm Reservation (Admin only)
- **Endpoint**: `PUT /api/reservations/:id/confirm`
- **Body**:
  ```json
  {
    "table_number": "T01"
  }
  ```

### Get Reservation by ID
- **Endpoint**: `GET /api/reservations/:id`

### Pay Reservation
- **Endpoint**: `POST /api/reservations/:id/pay`
- **Body**:
  ```json
  {
    "payment_method": "card",
    "use_loyalty_points": true,
    "loyalty_points_to_use": 500
  }
  ```

### Cancel Reservation
- **Endpoint**: `DELETE /api/reservations/:id`

## Table Management

### Get Tables
- **Endpoint**: `GET /api/tables`
- **Query Params**: `available_only=true`

### Create Table (Admin only)
- **Endpoint**: `POST /api/tables`

### Update Table (Admin only)
- **Endpoint**: `PUT /api/tables/:id`

### Delete Table (Admin only)
- **Endpoint**: `DELETE /api/tables/:id`

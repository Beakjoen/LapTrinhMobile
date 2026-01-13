# Web API Project - Exam 05

Student: 1771020358
Course: Mobile Programming

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Configure Database:
   - Create a MySQL database named `db_exam_1771020358`.
   - Update `.env` file with your database credentials (DB_USER, DB_PASS).

3. Run Migrations and Seeders:
   ```bash
   npx sequelize-cli db:migrate
   npx sequelize-cli db:seed:all
   ```

4. Run Server:
   ```bash
   npm start
   ```

## API Documentation

See `API_DOCUMENTATION.md` for details.

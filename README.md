# Coffee API

A RESTful API service for managing coffee types, built with Express.js, TypeScript, and MongoDB.

## Features

- CRUD operations for coffee types
- MongoDB integration
- TypeScript support
- Docker support for multiple environments
- Health check endpoint
- Development and QA environments

## Prerequisites

- Node.js (v20 or later)
- MongoDB
- Docker and Docker Compose (for containerized development)

## Project Structure

```
coffee_api/
├── src/
│   ├── controllers/    # Request handlers
│   ├── models/        # Database models
│   ├── routes/        # API routes
│   ├── config/        # Configuration files
│   └── index.ts       # Application entry point
├── scripts/           # Utility scripts
├── docker/           # Docker configuration
└── tests/            # Test suite
```

## Getting Started

### Local Development

1. Install dependencies:
   ```bash
   npm install
   ```

2. Create a `.env` file in the root directory:
   ```
   PORT=8000
   MONGODB_URI=mongodb://localhost:27017/coffee_db
   NODE_ENV=development
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

### Docker Development

The project supports multiple environments that can run simultaneously:

1. **Development Environment:**
   ```bash
   docker-compose -f docker-compose.dev.yml up
   ```
   - API: http://localhost:8000
   - MongoDB: localhost:27017

2. **QA Environment:**
   ```bash
   docker-compose -f docker-compose.qa.yml up
   ```
   - API: http://localhost:8001
   - MongoDB: localhost:27018

3. **Run Both Environments:**
   ```bash
   ./scripts/run-environments.sh
   ```
   This script will start both environments and provide a nice interface to monitor them.

### Environment Differences

1. **Development:**
   - Hot-reloading enabled
   - Source code mounted as volume
   - Debug-friendly settings
   - Port 8000
   - Database: coffee_db_dev

2. **QA:**
   - Production-like build
   - Optimized for testing
   - Port 8001
   - Database: coffee_db_qa

## API Endpoints

- `GET /api/v1/health` - Health check
- `GET /api/v1/coffees` - Get all coffees
- `GET /api/v1/coffees/:id` - Get a specific coffee
- `POST /api/v1/coffees` - Create a new coffee
- `PUT /api/v1/coffees/:id` - Update a coffee
- `DELETE /api/v1/coffees/:id` - Delete a coffee

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm start` - Start production server
- `npm run lint` - Run ESLint
- `npm test` - Run tests

## Database Access

### Development MongoDB
```bash
docker-compose -f docker-compose.dev.yml exec mongodb_dev mongosh
```

### QA MongoDB
```bash
docker-compose -f docker-compose.qa.yml exec mongodb_qa mongosh
```

## MongoDB Commands

Here are some useful MongoDB commands:

```js
// Show databases
show dbs

// Use database
use coffee_db_dev  // or coffee_db_qa

// Show collections
show collections

// Find all coffees
db.coffees.find().pretty()

// Find by name
db.coffees.find({ name: "Ethiopian Yirgacheffe" })

// Find by price range
db.coffees.find({ price: { $gt: 10, $lt: 15 } })
```

## License

ISC 
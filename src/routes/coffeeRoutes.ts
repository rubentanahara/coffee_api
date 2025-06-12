import { Router, RequestHandler } from 'express';
import { coffeeController } from '../controllers/coffeeController';

const router = Router();

// GET /api/v1/coffees
router.get('/', coffeeController.getAllCoffees as RequestHandler);

// GET /api/v1/coffees/:id
router.get('/:id', coffeeController.getCoffeeById as RequestHandler);

// POST /api/v1/coffees
router.post('/', coffeeController.createCoffee as RequestHandler);

// PUT /api/v1/coffees/:id
router.put('/:id', coffeeController.updateCoffee as RequestHandler);

// DELETE /api/v1/coffees/:id
router.delete('/:id', coffeeController.deleteCoffee as RequestHandler);

export default router; 
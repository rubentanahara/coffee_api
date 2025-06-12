import { Request, Response } from 'express';
import { Coffee, ICoffee } from '../models/Coffee';

export const coffeeController = {
  // Get all coffees
  getAllCoffees: async (req: Request, res: Response) => {
    try {
      const coffees = await Coffee.find();
      res.json(coffees);
    } catch (error) {
      res.status(500).json({ message: 'Error fetching coffees', error });
    }
  },

  // Get a single coffee by ID
  getCoffeeById: async (req: Request, res: Response) => {
    try {
      const coffee = await Coffee.findById(req.params.id);
      if (!coffee) {
        return res.status(404).json({ message: 'Coffee not found' });
      }
      res.json(coffee);
    } catch (error) {
      res.status(500).json({ message: 'Error fetching coffee', error });
    }
  },

  // Create a new coffee
  createCoffee: async (req: Request, res: Response) => {
    try {
      const coffee = new Coffee(req.body);
      const savedCoffee = await coffee.save();
      res.status(201).json(savedCoffee);
    } catch (error) {
      res.status(400).json({ message: 'Error creating coffee', error });
    }
  },

  // Update a coffee
  updateCoffee: async (req: Request, res: Response) => {
    try {
      const coffee = await Coffee.findByIdAndUpdate(
        req.params.id,
        req.body,
        { new: true, runValidators: true }
      );
      if (!coffee) {
        return res.status(404).json({ message: 'Coffee not found' });
      }
      res.json(coffee);
    } catch (error) {
      res.status(400).json({ message: 'Error updating coffee', error });
    }
  },

  // Delete a coffee
  deleteCoffee: async (req: Request, res: Response) => {
    try {
      const coffee = await Coffee.findByIdAndDelete(req.params.id);
      if (!coffee) {
        return res.status(404).json({ message: 'Coffee not found' });
      }
      res.status(204).send();
    } catch (error) {
      res.status(500).json({ message: 'Error deleting coffee', error });
    }
  }
}; 
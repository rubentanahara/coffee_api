import mongoose, { Document, Schema } from 'mongoose';

export interface ICoffee extends Document {
  name: string;
  description: string;
  origin: string;
  roastLevel: string;
  price: number;
  isAvailable: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const coffeeSchema = new Schema<ICoffee>(
  {
    name: { type: String, required: true },
    description: { type: String, required: true },
    origin: { type: String, required: true },
    roastLevel: { type: String, required: true },
    price: { type: Number, required: true },
    isAvailable: { type: Boolean, default: true },
  },
  { timestamps: true }
);

export const Coffee = mongoose.model<ICoffee>('Coffee', coffeeSchema); 
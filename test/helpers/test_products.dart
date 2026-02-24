// Test helper: shared test product fixtures.
import 'package:beespoke_app/features/products/domain/models/product.dart';

const testProducts = [
  Product(
    id: 1,
    title: 'Fjallraven Backpack',
    price: 109.95,
    description: 'A backpack for all occasions',
    category: 'clothing',
    imageUrl: 'https://fakestoreapi.com/img/81fAn.jpg',
    rating: 3.9,
    ratingCount: 120,
  ),
  Product(
    id: 2,
    title: 'Casual Premium T-Shirt',
    price: 22.30,
    description: 'Comfortable casual t-shirt',
    category: 'clothing',
    imageUrl: 'https://fakestoreapi.com/img/71YXzeOusl.jpg',
    rating: 4.1,
    ratingCount: 259,
  ),
];

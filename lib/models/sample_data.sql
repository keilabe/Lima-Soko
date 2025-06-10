-- Insert sample categories
INSERT INTO public.categories (id, name, description, parent_id) VALUES
    ('c1', 'Vegetables', 'Fresh vegetables from local farmers', NULL),
    ('c2', 'Fruits', 'Seasonal and exotic fruits', NULL),
    ('c3', 'Grains', 'Various types of grains and cereals', NULL),
    ('c4', 'Dairy', 'Fresh dairy products', NULL),
    ('c5', 'Herbs', 'Fresh herbs and spices', NULL),
    ('c6', 'Organic', 'Certified organic produce', NULL);

-- Insert sample products
INSERT INTO public.products (id, name, description, price, category_id, seller_id, stock_quantity, images, is_active) VALUES
    -- Vegetables
    ('p1', 'Fresh Tomatoes', 'Organic tomatoes grown locally', 2.99, 'c1', '0d0abc0c-3f46-4063-900c-229eac14bd17', 100, 
        ARRAY['https://images.unsplash.com/photo-1546094097-246e1c693f3b?w=500'], true),
    ('p2', 'Organic Spinach', 'Fresh organic spinach leaves', 3.49, 'c1', '0d0abc0c-3f46-4063-900c-229eac14bd17', 50,
        ARRAY['https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500'], true),
    ('p3', 'Sweet Potatoes', 'Fresh sweet potatoes', 4.99, 'c1', '856c9be6-d9bb-4c8e-8705-8b5a049d50192', 75,
        ARRAY['https://images.unsplash.com/photo-1596097635121-14b63b7a0c19?w=500'], true),
    ('p4', 'Green Beans', 'Fresh green beans', 3.99, 'c1', 'bd2e043b-1e40-4224-923f-ec344ce34807', 60,
        ARRAY['https://images.unsplash.com/photo-1567375698348-5d9d5ae99de0?w=500'], true),

    -- Fruits
    ('p5', 'Red Apples', 'Sweet and crispy red apples', 4.99, 'c2', '856c9be6-d9bb-4c8e-8705-8b5a049d50192', 75,
        ARRAY['https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=500'], true),
    ('p6', 'Fresh Oranges', 'Juicy sweet oranges', 3.99, 'c2', 'bd2e043b-1e40-4224-923f-ec344ce34807', 100,
        ARRAY['https://images.unsplash.com/photo-1547514701-42782101795e?w=500'], true),
    ('p7', 'Ripe Bananas', 'Fresh yellow bananas', 2.99, 'c2', '0d0abc0c-3f46-4063-900c-229eac14bd17', 150,
        ARRAY['https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500'], true),
    ('p8', 'Fresh Strawberries', 'Sweet and juicy strawberries', 5.99, 'c2', '856c9be6-d9bb-4c8e-8705-8b5a049d50192', 40,
        ARRAY['https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=500'], true),

    -- Grains
    ('p9', 'Organic Quinoa', 'Premium organic quinoa grains', 8.99, 'c3', 'bd2e043b-1e40-4224-923f-ec344ce34807', 200,
        ARRAY['https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500'], true),
    ('p10', 'Brown Rice', 'Whole grain brown rice', 6.99, 'c3', '0d0abc0c-3f46-4063-900c-229eac14bd17', 150,
        ARRAY['https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500'], true),
    ('p11', 'Oats', 'Whole grain oats', 5.99, 'c3', '856c9be6-d9bb-4c8e-8705-8b5a049d50192', 180,
        ARRAY['https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=500'], true),
    ('p12', 'Barley', 'Whole grain barley', 7.99, 'c3', 'bd2e043b-1e40-4224-923f-ec344ce34807', 120,
        ARRAY['https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=500'], true),

    -- Dairy
    ('p13', 'Fresh Milk', 'Farm-fresh whole milk', 3.99, 'c4', 'fbd9985c-ceb3-4298-be94-83045bace6b3', 150,
        ARRAY['https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500'], true),
    ('p14', 'Farm Cheese', 'Artisanal farm cheese', 6.99, 'c4', 'fbd9985c-ceb3-4298-be94-83045bace6b3', 80,
        ARRAY['https://images.unsplash.com/photo-1452195100486-9cc805987862?w=500'], true),
    ('p15', 'Yogurt', 'Creamy natural yogurt', 4.99, 'c4', 'fbd9985c-ceb3-4298-be94-83045bace6b3', 100,
        ARRAY['https://images.unsplash.com/photo-1488477181946-6428a8481b19?w=500'], true),
    ('p16', 'Butter', 'Fresh farm butter', 5.99, 'c4', 'fbd9985c-ceb3-4298-be94-83045bace6b3', 90,
        ARRAY['https://images.unsplash.com/photo-1589985273615-91fcf21ebc42?w=500'], true),

    -- Herbs
    ('p17', 'Fresh Basil', 'Organic fresh basil', 2.99, 'c5', '0d0abc0c-3f46-4063-900c-229eac14bd17', 50,
        ARRAY['https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500'], true),
    ('p18', 'Mint Leaves', 'Fresh mint leaves', 2.49, 'c5', '856c9be6-d9bb-4c8e-8705-8b5a049d50192', 60,
        ARRAY['https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500'], true),
    ('p19', 'Rosemary', 'Fresh rosemary', 2.99, 'c5', 'bd2e043b-1e40-4224-923f-ec344ce34807', 40,
        ARRAY['https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500'], true),
    ('p20', 'Thyme', 'Fresh thyme', 2.49, 'c5', '0d0abc0c-3f46-4063-900c-229eac14bd17', 45,
        ARRAY['https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500'], true),

    -- Organic
    ('p21', 'Organic Carrots', 'Fresh organic carrots', 3.99, 'c6', '856c9be6-d9bb-4c8e-8705-8b5a049d50192', 70,
        ARRAY['https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=500'], true),
    ('p22', 'Organic Potatoes', 'Fresh organic potatoes', 4.49, 'c6', 'bd2e043b-1e40-4224-923f-ec344ce34807', 90,
        ARRAY['https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=500'], true),
    ('p23', 'Organic Onions', 'Fresh organic onions', 3.49, 'c6', '0d0abc0c-3f46-4063-900c-229eac14bd17', 85,
        ARRAY['https://images.unsplash.com/photo-1508747703725-719777637510?w=500'], true),
    ('p24', 'Organic Garlic', 'Fresh organic garlic', 2.99, 'c6', '856c9be6-d9bb-4c8e-8705-8b5a049d50192', 65,
        ARRAY['https://images.unsplash.com/photo-1540148426945-6cf22a6b2383?w=500'], true);


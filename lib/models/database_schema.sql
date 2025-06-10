-- Database Schema for Lima Soko

-- Migration Script: This script is designed to be run on an *existing* Supabase database.
-- It will modify tables, update RLS policies, and ensure triggers are correctly set up.

-- Create necessary extensions if not already created
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ALTER TABLE public.profiles to add new columns if they don't exist
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS full_name TEXT,
ADD COLUMN IF NOT EXISTS phone_number TEXT,
ADD COLUMN IF NOT EXISTS role TEXT CHECK (role IN ('farmer', 'buyer'));

-- ALTER TABLE public.products to add new columns if they don't exist
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS rating NUMERIC DEFAULT 0.0,
ADD COLUMN IF NOT EXISTS reviews INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS varieties TEXT[],
ADD COLUMN IF NOT EXISTS weights TEXT[];

-- Update existing profiles to have a default role if they are null. 
-- IMPORTANT: Review this UPDATE statement to assign roles based on your existing user data if available.
-- For new signups, the role is set in the Flutter app.
UPDATE public.profiles 
SET role = 'buyer' 
WHERE role IS NULL;

-- Make role column NOT NULL after setting default values, if it's not already.
ALTER TABLE public.profiles 
ALTER COLUMN role SET NOT NULL;

-- Add mock categories if they don't exist
INSERT INTO public.categories (id, name, description)
SELECT uuid_generate_v4(), 'Vegetables', 'Fresh and organic vegetables'
WHERE NOT EXISTS (SELECT 1 FROM public.categories WHERE name = 'Vegetables');

INSERT INTO public.categories (id, name, description)
SELECT uuid_generate_v4(), 'Fruits', 'Delicious and nutritious fruits'
WHERE NOT EXISTS (SELECT 1 FROM public.categories WHERE name = 'Fruits');

INSERT INTO public.categories (id, name, description)
SELECT uuid_generate_v4(), 'Baked Goods', 'Freshly baked breads and pastries'
WHERE NOT EXISTS (SELECT 1 FROM public.categories WHERE name = 'Baked Goods');

-- Ensure a farmer profile exists for product inserts
INSERT INTO public.profiles (id, full_name, phone_number, role)
SELECT uuid_generate_v4(), 'Default Farmer', '000-000-0000', 'farmer'
WHERE NOT EXISTS (SELECT 1 FROM public.profiles WHERE role = 'farmer');

-- Add mock products if they don't exist
INSERT INTO public.products (id, name, description, price, category_id, seller_id, stock_quantity, images, is_active, rating, reviews, varieties, weights)
SELECT
    uuid_generate_v4()::text,
    'Farm Fresh Tomatoes',
    'These tomatoes are vine-ripened and bursting with flavor. Perfect for salads, sauces, or just snacking.',
    3.50,
    (SELECT id FROM public.categories WHERE name = 'Vegetables' LIMIT 1)::text,
    (SELECT id FROM public.profiles WHERE role = 'farmer' LIMIT 1)::text,
    100,
    ARRAY['https://via.placeholder.com/400x300.png?text=Farm+Fresh+Tomatoes'],
    TRUE,
    4.5,
    29,
    ARRAY['red', 'green', 'yellow'],
    ARRAY['1 lb', '2 lb', '5 lb']
WHERE NOT EXISTS (SELECT 1 FROM public.products WHERE name = 'Farm Fresh Tomatoes');

INSERT INTO public.products (id, name, description, price, category_id, seller_id, stock_quantity, images, is_active, rating, reviews, varieties, weights)
SELECT
    uuid_generate_v4()::text,
    'Organic Blueberries',
    'Sweet and juicy organic blueberries, perfect for snacks, smoothies, or baking.',
    5.99,
    (SELECT id FROM public.categories WHERE name = 'Fruits' LIMIT 1)::text,
    (SELECT id FROM public.profiles WHERE role = 'farmer' LIMIT 1)::text,
    50,
    ARRAY['https://via.placeholder.com/400x300.png?text=Organic+Blueberries'],
    TRUE,
    4.8,
    45,
    ARRAY['blue', 'purple'],
    ARRAY['0.5 lb', '1 lb']
WHERE NOT EXISTS (SELECT 1 FROM public.products WHERE name = 'Organic Blueberries');

INSERT INTO public.products (id, name, description, price, category_id, seller_id, stock_quantity, images, is_active, rating, reviews, varieties, weights)
SELECT
    uuid_generate_v4()::text,
    'Freshly Baked Bread',
    'Artisan sourdough bread, baked fresh daily with organic ingredients.',
    4.25,
    (SELECT id FROM public.categories WHERE name = 'Baked Goods' LIMIT 1)::text,
    (SELECT id FROM public.profiles WHERE role = 'farmer' LIMIT 1)::text,
    30,
    ARRAY['https://via.placeholder.com/400x300.png?text=Freshly+Baked+Bread'],
    TRUE,
    4.7,
    60,
    ARRAY['white', 'brown'],
    ARRAY['1 loaf', '2 loafs']
WHERE NOT EXISTS (SELECT 1 FROM public.products WHERE name = 'Freshly Baked Bread');

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_seller ON public.products(seller_id);
CREATE INDEX IF NOT EXISTS idx_orders_user ON public.orders(user_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON public.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_cart_user ON public.cart(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_product ON public.reviews(product_id);

-- Enable Row Level Security (RLS) for all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cart ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

-- Drop and recreate RLS policies to ensure they are up-to-date and without conflicts.

-- Profiles policies
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
CREATE POLICY "Users can view their own profile"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
CREATE POLICY "Users can update their own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

-- Consolidated policy for profile insertion. 
-- This allows an authenticated user to insert their own profile, provided the ID matches auth.uid().
DROP POLICY IF EXISTS "Allow authenticated user to insert their own profile" ON public.profiles;
CREATE POLICY "Allow authenticated user to insert their own profile"
    ON public.profiles FOR INSERT
    WITH CHECK (
        auth.uid() = id
    );

-- Products policies
DROP POLICY IF EXISTS "Anyone can view products" ON public.products;
CREATE POLICY "Anyone can view products"
    ON public.products FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Farmers can insert their own products" ON public.products;
CREATE POLICY "Farmers can insert their own products"
    ON public.products FOR INSERT
    WITH CHECK (
        auth.uid()::text = seller_id AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'farmer'
        )
    );

DROP POLICY IF EXISTS "Farmers can update their own products" ON public.products;
CREATE POLICY "Farmers can update their own products"
    ON public.products FOR UPDATE
    USING (
        auth.uid()::text = seller_id AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'farmer'
        )
    );

DROP POLICY IF EXISTS "Farmers can delete their own products" ON public.products;
CREATE POLICY "Farmers can delete their own products"
    ON public.products FOR DELETE
    USING (
        auth.uid()::text = seller_id AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'farmer'
        )
    );

-- Categories policies
DROP POLICY IF EXISTS "Anyone can view categories" ON public.categories;
CREATE POLICY "Anyone can view categories"
    ON public.categories FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Only farmers can manage categories" ON public.categories;
CREATE POLICY "Only farmers can manage categories"
    ON public.categories FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'farmer'
        )
    );

-- Orders policies
DROP POLICY IF EXISTS "Users can view their own orders" ON public.orders;
CREATE POLICY "Users can view their own orders"
    ON public.orders FOR SELECT
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Buyers can create their own orders" ON public.orders;
CREATE POLICY "Buyers can create their own orders"
    ON public.orders FOR INSERT
    WITH CHECK (
        auth.uid() = user_id AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'buyer'
        )
    );

DROP POLICY IF EXISTS "Users can update their own orders" ON public.orders;
CREATE POLICY "Users can update their own orders"
    ON public.orders FOR UPDATE
    USING (auth.uid() = user_id);

-- Order Items policies
DROP POLICY IF EXISTS "Users can view their own order items" ON public.order_items;
CREATE POLICY "Users can view their own order items"
    ON public.order_items FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.orders
            WHERE orders.id = order_items.order_id
            AND orders.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "Buyers can create their own order items" ON public.order_items;
CREATE POLICY "Buyers can create their own order items"
    ON public.order_items FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.orders
            WHERE orders.id = order_items.order_id
            AND orders.user_id = auth.uid()
            AND EXISTS (
                SELECT 1 FROM public.profiles
                WHERE id = auth.uid() AND role = 'buyer'
            )
        )
    );

-- Cart policies
DROP POLICY IF EXISTS "Users can view their own cart" ON public.cart;
CREATE POLICY "Users can view their own cart"
    ON public.cart FOR SELECT
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own cart" ON public.cart;
CREATE POLICY "Users can update their own cart"
    ON public.cart FOR UPDATE
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert into their own cart" ON public.cart;
CREATE POLICY "Users can insert into their own cart"
    ON public.cart FOR INSERT
    WITH CHECK (
        auth.uid() = user_id AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'buyer'
        )
    );

DROP POLICY IF EXISTS "Users can delete from their own cart" ON public.cart;
CREATE POLICY "Users can delete from their own cart"
    ON public.cart FOR DELETE
    USING (auth.uid() = user_id);

-- Reviews policies
DROP POLICY IF EXISTS "Anyone can view reviews" ON public.reviews;
CREATE POLICY "Anyone can view reviews"
    ON public.reviews FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Users can insert their own reviews" ON public.reviews;
CREATE POLICY "Users can insert their own reviews"
    ON public.reviews FOR INSERT
    WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own reviews" ON public.reviews;
CREATE POLICY "Users can update their own reviews"
    ON public.reviews FOR UPDATE
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own reviews" ON public.reviews;
CREATE POLICY "Users can delete their own reviews"
    ON public.reviews FOR DELETE
    USING (auth.uid() = user_id);

-- Payments Table (for M-Pesa transactions)
CREATE TABLE IF NOT EXISTS public.payments (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    order_id uuid REFERENCES public.orders(id) ON DELETE CASCADE,
    amount NUMERIC(10, 2) NOT NULL,
    transaction_id TEXT UNIQUE NOT NULL, -- M-Pesa specific transaction ID
    status TEXT NOT NULL, -- e.g., 'pending', 'completed', 'failed'
    payment_method TEXT DEFAULT 'M-Pesa' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own payments" ON public.payments FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own payments" ON public.payments FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Set up a function to update the 'updated_at' column automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to the payments table
CREATE TRIGGER update_payments_updated_at
BEFORE UPDATE ON public.payments
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Triggers for other tables (ensure these exist and are correctly configured)
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON public.products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_updated_at
    BEFORE UPDATE ON public.categories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cart_updated_at
    BEFORE UPDATE ON public.cart
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reviews_updated_at
    BEFORE UPDATE ON public.reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 
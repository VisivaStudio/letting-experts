
-- FINAL REPAIR & SEED SCRIPT
-- RUN THIS TO FIX ALL MISSING DATA AND SCHEMA ISSUES

-- 1. Add missing columns to 'listings' table
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='listings' AND column_name='is_featured') THEN
        ALTER TABLE public.listings ADD COLUMN is_featured boolean DEFAULT false;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='listings' AND column_name='lat') THEN
        ALTER TABLE public.listings ADD COLUMN lat double precision;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='listings' AND column_name='lng') THEN
        ALTER TABLE public.listings ADD COLUMN lng double precision;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='listings' AND column_name='agent') THEN
        ALTER TABLE public.listings ADD COLUMN agent text DEFAULT 'Letting Experts';
    END IF;
END $$;

-- 2. Clear existing data to avoid duplicates
TRUNCATE public.listing_media CASCADE;
TRUNCATE public.listings CASCADE;
TRUNCATE public.areas CASCADE;

-- 3. Insert Areas
INSERT INTO public.areas (id, name, city, province) VALUES
(1, 'Rooihuiskraal North', 'Centurion', 'Gauteng'),
(2, 'Hennopspark', 'Centurion', 'Gauteng'),
(3, 'Wierda Park', 'Centurion', 'Gauteng'),
(4, 'Eldoraigne', 'Centurion', 'Gauteng');

-- 4. Insert Real Property24 Listings for Letting Experts
INSERT INTO public.listings (id, title, description, property_type, rent, bedrooms, bathrooms, parking, address, is_active, is_featured, area_id, lat, lng, agent) VALUES
(1, '2 Bed Townhouse in Rooihuiskraal North', 'Neat and pet-friendly 2-bedroom townhouse in a secure complex. Features 2 bathrooms and private yard.', 'townhouse', 8350.00, 2, 2, 1, 'Rooihuiskraal North, Centurion', true, true, 1, -25.8856, 28.1408, 'Quinton Milligan'),
(2, 'Spacious 4 Bed Family Home', 'Well-maintained house walking distance to schools. Features open-plan kitchen, large garden, and excellent security.', 'house', 19000.00, 4, 3, 2, 'Hennopspark, Centurion', true, true, 2, -25.8711, 28.1633, 'Pieter Jordaan'),
(3, 'Modern 3 Bed in Wierda Park', 'Stunning family home with high-end finishes and spacious living areas in the heart of Wierda Park.', 'house', 14500.00, 3, 2, 2, 'Wierda Park, Centurion', true, false, 3, -25.8600, 28.1450, 'Dylan Du Toit'),
(4, 'Luxury Residence in Eldoraigne', 'Designer home with massive open-plan spaces and a landscaped garden. Top-tier security.', 'house', 15500.00, 3, 3, 2, 'Eldoraigne, Centurion', true, false, 4, -25.8450, 28.1550, 'Suanita Joubert');

-- 5. Insert Media
INSERT INTO public.listing_media (listing_id, url, sort_order) VALUES
(1, 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=1200&q=80', 0),
(1, 'https://images.unsplash.com/photo-1512918766775-d249d665305c?auto=format&fit=crop&w=1200&q=80', 1),
(2, 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80', 0),
(2, 'https://images.unsplash.com/photo-1600573472591-ee6b68d14c68?auto=format&fit=crop&w=1200&q=80', 1),
(3, 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=1200&q=80', 0),
(4, 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1200&q=80', 0);

-- 6. RESET SEQUENCES
SELECT setval('areas_id_seq', (SELECT MAX(id) FROM areas));
SELECT setval('listings_id_seq', (SELECT MAX(id) FROM listings));

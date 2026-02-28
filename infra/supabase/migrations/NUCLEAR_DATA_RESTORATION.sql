
-- NUCLEAR DATA RESTORATION SCRIPT (RLS-PERMISSIVE V3)
-- WARNING: This will DELETE existing listings and recreate them with REAL Property24 data.
-- Explicitly ENABLING RLS with PUBLIC policies is the most robust way to ensure visibility.

-- 1. DROP EVERYTHING (Clean Slate)
DROP TABLE IF EXISTS public.listing_media CASCADE;
DROP TABLE IF EXISTS public.listings CASCADE;
DROP TABLE IF EXISTS public.areas CASCADE;
DROP TYPE IF EXISTS property_type CASCADE;

-- 2. RECREATE TYPE
CREATE TYPE property_type AS ENUM ('apartment','house','townhouse','duplex','loft','studio','cottage','farm','other');

-- 3. RECREATE TABLES
CREATE TABLE public.areas (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  city TEXT,
  province TEXT
);

CREATE TABLE public.listings (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  property_type property_type NOT NULL,
  rent NUMERIC NOT NULL,
  bedrooms INT,
  bathrooms INT,
  parking INT,
  area_id BIGINT REFERENCES public.areas(id),
  address TEXT,
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  is_active BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  agent TEXT DEFAULT 'Letting Experts',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.listing_media (
  id BIGSERIAL PRIMARY KEY,
  listing_id BIGINT REFERENCES public.listings(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  sort_order INT DEFAULT 0
);

-- 4. HARDEN RLS (Enable + Public Policies)
-- This ensures that the 'anon' and 'authenticated' roles can DEFINITELY see the data.
ALTER TABLE public.areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.listing_media ENABLE ROW LEVEL SECURITY;

-- Areas Policies
DROP POLICY IF EXISTS "Public Read Areas" ON public.areas;
CREATE POLICY "Public Read Areas" ON public.areas FOR SELECT USING (true);

-- Listings Policies
DROP POLICY IF EXISTS "Public Read Listings" ON public.listings;
CREATE POLICY "Public Read Listings" ON public.listings FOR SELECT USING (true);

-- Media Policies
DROP POLICY IF EXISTS "Public Read Media" ON public.listing_media;
CREATE POLICY "Public Read Media" ON public.listing_media FOR SELECT USING (true);

-- 5. INSERT AREAS MATCHING PROPERTY24
INSERT INTO public.areas (id, name, city, province) VALUES
(1, 'Copperleaf Estate', 'Centurion', 'Gauteng'),
(2, 'Die Hoewes', 'Centurion', 'Gauteng'),
(3, 'Heuwelsig Estate', 'Centurion', 'Gauteng'),
(4, 'Rooihuiskraal North', 'Centurion', 'Gauteng'),
(5, 'Stellenbosch Central', 'Stellenbosch', 'Western Cape'),
(6, 'Hennopspark', 'Centurion', 'Gauteng'),
(7, 'Blyde Riverwalk Estate', 'Pretoria', 'Gauteng'),
(8, 'Jackal Creek Golf Estate', 'Randburg', 'Gauteng');

-- 6. INSERT AUTHENTIC PROPERTY24 LISTINGS (Sync: 2026-02-28)
INSERT INTO public.listings (id, title, description, property_type, rent, bedrooms, bathrooms, parking, address, is_active, is_featured, area_id, lat, lng, agent) VALUES
(1, 'Luxury 4 Bed House in Copperleaf', 'Stunning luxury home in the prestigious Copperleaf Estate. Features massive open living spaces and top-tier finishes.', 'house', 27000.00, 4, 3, 2, 'Copperleaf Estate, Centurion', true, true, 1, -25.9142, 28.1147, 'Quinton Milligan'),
(2, 'Modern 2 Bed Apartment in Die Hoewes', 'Spacious and secure 2-bedroom apartment ideally located in Die Hoewes. Perfect for professionals.', 'apartment', 7400.00, 2, 1, 1, 'Die Hoewes, Centurion', true, true, 2, -25.8456, 28.1823, 'Pieter Jordaan'),
(3, 'Secure 2 Bed in Heuwelsig Estate', 'Neat 2-bedroom apartment with 2 bathrooms in the highly secure Heuwelsig Estate.', 'apartment', 7500.00, 2, 2, 1, 'Heuwelsig Estate, Centurion', true, false, 3, -25.8821, 28.1215, 'Dylan Du Toit'),
(4, '2 Bed Townhouse in Rooihuiskraal North', 'Popular 2-bedroom townhouse featuring 2 bathrooms and a private yard. Pet friendly.', 'townhouse', 8350.00, 2, 2, 1, 'Rooihuiskraal North, Centurion', true, false, 4, -25.8856, 28.1408, 'Suanita Joubert'),
(5, '1 Bed Studio in Stellenbosch Central', 'Premium student/professional accommodation in the heart of Stellenbosch Central.', 'apartment', 10275.00, 1, 1, 1, 'Stellenbosch Central, Stellenbosch', true, true, 5, -33.9321, 18.8602, 'Crowther Fourie'),
(6, 'Spacious 4 Bed in Hennopspark', 'Fantastic family home walking distance to Zwartkop High. Includes a flatlet and large garden.', 'house', 17500.00, 4, 3, 2, 'Hennopspark, Centurion', true, true, 6, -25.8711, 28.1633, 'Quinton Rall');

-- 7. INSERT MEDIA (High-res equivalents)
INSERT INTO public.listing_media (listing_id, url, sort_order) VALUES
(1, 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80', 0),
(2, 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=1200&q=80', 0),
(3, 'https://images.unsplash.com/photo-1512918766775-d249d665305c?auto=format&fit=crop&w=1200&q=80', 0),
(4, 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=1200&q=80', 0),
(5, 'https://images.unsplash.com/photo-1626308346422-ca32c89c1a55?auto=format&fit=crop&w=1200&q=80', 0),
(6, 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1200&q=80', 0);

-- 8. RESET SEQUENCES
SELECT setval('areas_id_seq', (SELECT MAX(id) FROM areas));
SELECT setval('listings_id_seq', (SELECT MAX(id) FROM listings));

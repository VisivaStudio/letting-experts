
-- Seed Data for Letting Experts

-- 1. Insert Areas
INSERT INTO public.areas (name, city, province) VALUES
('Eldoraigne', 'Centurion', 'Gauteng'),
('Pretoria East', 'Pretoria', 'Gauteng'),
('Midrand', 'Johannesburg', 'Gauteng'),
('Stellenbosch', 'Winelands', 'Western Cape');

-- 2. Insert Listings
INSERT INTO public.listings (title, description, property_type, rent, bedrooms, bathrooms, parking, address, is_active, area_id) VALUES
(
  'Ultra-Modern 3 Bed in Eldoraigne', 
  'A stunning contemporary home featuring open-plan living, designer finishes, and a private landscaped garden. Perfect for a modern family seeking security and style.', 
  'house', 
  15500.00, 
  3, 2, 2, 
  '123 Saxby Avenue, Eldoraigne', 
  true, 
  1
),
(
  'Luxury Sky Penthouse', 
  'Breathtaking views of the city skyline. This penthouse offers floor-to-ceiling windows, a private pool, and automated home systems throughout.', 
  'apartment', 
  24000.00, 
  2, 2, 2, 
  'Tower Heights, Pretoria East', 
  true, 
  2
),
(
  'Corporate Office Suite', 
  'Versatile commercial space situated in the heart of Midrand. High visibility, dedicated reception area, and ample parking for clients.', 
  'commercial', 
  12800.00, 
  0, 2, 4, 
  'Midrand Business Park', 
  true, 
  3
),
(
  'Charming Vineyard Villa', 
  'Escape to the Winelands in this beautiful villa surrounded by mountains and vineyards. High ceilings, stone fireplaces, and rustic elegance.', 
  'house', 
  28500.00, 
  4, 3, 3, 
  'Stellenbosch Manor Estates', 
  true, 
  4
);

-- 3. Insert Listing Media (Using Unsplash High-Res images)
-- Listing 1
INSERT INTO public.listing_media (listing_id, url, sort_order) VALUES
(1, 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80', 0),
(1, 'https://images.unsplash.com/photo-1600566753190-17f0bb2a6c3e?auto=format&fit=crop&w=1200&q=80', 1),
(1, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 2);

-- Listing 2
INSERT INTO public.listing_media (listing_id, url, sort_order) VALUES
(2, 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=1200&q=80', 0),
(2, 'https://images.unsplash.com/photo-1512918766775-d249d665305c?auto=format&fit=crop&w=1200&q=80', 1);

-- Listing 3
INSERT INTO public.listing_media (listing_id, url, sort_order) VALUES
(3, 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=1200&q=80', 0),
(3, 'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=1200&q=80', 1);

-- Listing 4
INSERT INTO public.listing_media (listing_id, url, sort_order) VALUES
(4, 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=1200&q=80', 0),
(4, 'https://images.unsplash.com/photo-1523217582562-09d0def993a6?auto=format&fit=crop&w=1200&q=80', 1);

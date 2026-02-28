
-- Real-World Listing Seed Data for Letting Experts Centurion (Source: Property24)

-- 1. Ensure Areas exist
INSERT INTO public.areas (name, city, province) VALUES
('Rooihuiskraal North', 'Centurion', 'Gauteng'),
('Hennopspark', 'Centurion', 'Gauteng'),
('Wierda Park', 'Centurion', 'Gauteng'),
('Eldoraigne', 'Centurion', 'Gauteng');

-- 2. Insert Authentic Listings
-- Property 1: Rooihuiskraal North Townhouse
INSERT INTO public.listings (title, description, property_type, rent, bedrooms, bathrooms, parking, address, is_active, area_id) VALUES
(
  '2 Bed Townhouse in Rooihuiskraal North', 
  'Neat and spacious 2-bedroom townhouse in a secure complex. Features 2 bathrooms, private yard, and pet-friendly environment. Ideally located near Mall@Reds with easy access to R55 and N14.', 
  'townhouse', 
  8350.00, 
  2, 2, 1, 
  'Rooihuiskraal North, Centurion', 
  true, 
  1
);

-- Property 2: Hennopspark 4-Bedroom House
INSERT INTO public.listings (title, description, property_type, rent, bedrooms, bathrooms, parking, address, is_active, area_id) VALUES
(
  'Spacious 4 Bed Family Home', 
  'Well-maintained 4-bedroom house walking distance to Hennopspark Primary & Zwartkop High. Features open-plan granite kitchen, large garden for kids, excellent security (24h response), and a flatlet. Gardener included.', 
  'house', 
  19000.00, 
  4, 2, 2, 
  'Hennopspark, Centurion', 
  true, 
  2
);

-- Property 3: Wierda Park Modern House
INSERT INTO public.listings (title, description, property_type, rent, bedrooms, bathrooms, parking, address, is_active, area_id) VALUES
(
  'Stunning 3 Bed Home in Wierda Park', 
  'Beautifully updated family home in the heart of Wierda Park. Features modern finishes throughout, ample parking, and spacious living areas. Close to primary schools and shopping centers.', 
  'house', 
  14500.00, 
  3, 2, 2, 
  'Wierda Park, Centurion', 
  true, 
  3
);

-- Property 4: Eldoraigne Luxury Residence
INSERT INTO public.listings (title, description, property_type, rent, bedrooms, bathrooms, parking, address, is_active, area_id) VALUES
(
  'Premium 3 Bed in Eldoraigne', 
  'Contemporary designer home featuring massive open-plan living, high-end finishes, and a landscaped garden. Perfect for a modern family seeking top-tier security in a prime Centurion location.', 
  'house', 
  15500.00, 
  3, 3, 2, 
  'Eldoraigne, Centurion', 
  true, 
  4
);

-- 3. Insert Authentic Media (High-res visuals matching the listings)
-- Listing 1
INSERT INTO public.listing_media (listing_id, url, sort_order) VALUES
(1, 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=1200&q=80', 0),
(1, 'https://images.unsplash.com/photo-1512918766775-d249d665305c?auto=format&fit=crop&w=1200&q=80', 1);

-- Listing 2
INSERT INTO public.listing_media (listing_id, url, sort_order) VALUES
(2, 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80', 0),
(2, 'https://images.unsplash.com/photo-1600566753190-17f0bb2a6c3e?auto=format&fit=crop&w=1200&q=80', 1),
(2, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 2);

-- Listing 3
INSERT INTO public.listing_media (listing_id, url, sort_order) VALUES
(3, 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=1200&q=80', 0),
(3, 'https://images.unsplash.com/photo-1523217582562-09d0def993a6?auto=format&fit=crop&w=1200&q=80', 1);

-- Listing 4
INSERT INTO public.listing_media (listing_id, url, sort_order) VALUES
(4, 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1200&q=80', 0),
(4, 'https://images.unsplash.com/photo-1600573472591-ee6b68d14c68?auto=format&fit=crop&w=1200&q=80', 1);

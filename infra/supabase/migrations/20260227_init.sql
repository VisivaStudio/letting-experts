create extension if not exists postgis;

create table if not exists public.profiles (
  id uuid primary key references auth.users on delete cascade,
  role text check (role in ('agent','tenant')) not null default 'tenant',
  full_name text,
  phone text,
  created_at timestamptz default now()
);

create type property_type as enum ('apartment','house','townhouse','duplex','loft','studio','cottage','farm','other');

create table if not exists public.areas (
  id bigserial primary key,
  name text not null,
  city text,
  province text,
  geom geometry(MULTIPOLYGON, 4326)
);

create table if not exists public.listings (
  id bigserial primary key,
  title text not null,
  description text,
  property_type property_type not null,
  rent numeric not null,
  deposit numeric,
  bedrooms int,
  bathrooms int,
  parking int,
  pets_allowed boolean default false,
  area_id bigint references public.areas(id),
  address text,
  coords geometry(POINT, 4326),
  available_from date,
  is_active boolean default true,
  created_by uuid references public.profiles(id),
  created_at timestamptz default now(),
  tsv tsvector generated always as (
    setweight(to_tsvector('english', coalesce(title,'')), 'A') ||
    setweight(to_tsvector('english', coalesce(description,'')), 'B')
  ) stored
);

create index if not exists listings_tsv_idx on public.listings using gin(tsv);
create index if not exists listings_coords_idx on public.listings using gist(coords);

create table if not exists public.listing_media (
  id bigserial primary key,
  listing_id bigint references public.listings(id) on delete cascade,
  url text not null,
  width int,
  height int,
  sort_order int default 0
);

create table if not exists public.leads (
  id bigserial primary key,
  listing_id bigint references public.listings(id) on delete cascade,
  sender_id uuid references public.profiles(id),
  message text,
  contact_via text check (contact_via in ('phone','email','whatsapp')),
  created_at timestamptz default now()
);

create table if not exists public.favorites (
  user_id uuid references public.profiles(id) on delete cascade,
  listing_id bigint references public.listings(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (user_id, listing_id)
);

create table if not exists public.saved_searches (
  id bigserial primary key,
  user_id uuid references public.profiles(id) on delete cascade,
  name text,
  filters jsonb not null,
  created_at timestamptz default now()
);

create table if not exists public.applications (
  id bigserial primary key,
  listing_id bigint references public.listings(id) on delete cascade,
  applicant_id uuid references public.profiles(id),
  status text check (status in ('submitted','in_review','approved','rejected')) default 'submitted',
  monthly_income numeric,
  notes text,
  created_at timestamptz default now()
);

create table if not exists public.application_documents (
  id bigserial primary key,
  application_id bigint references public.applications(id) on delete cascade,
  url text not null,
  kind text,
  uploaded_at timestamptz default now()
);

alter table public.profiles enable row level security;
alter table public.listings enable row level security;
alter table public.listing_media enable row level security;
alter table public.leads enable row level security;
alter table public.favorites enable row level security;
alter table public.saved_searches enable row level security;
alter table public.applications enable row level security;
alter table public.application_documents enable row level security;

create policy profiles_self_read on public.profiles for select using (auth.uid() = id);
create policy profiles_self_write on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);
create policy listings_read_active on public.listings for select using (is_active = true);
create policy listings_insert_agents on public.listings for insert with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'agent'));
create policy listings_update_owner on public.listings for update using (created_by = auth.uid());
create policy media_read_all on public.listing_media for select using (true);
create policy media_owner_write on public.listing_media for all using (exists (select 1 from public.listings l where l.id = listing_id and l.created_by = auth.uid()));
create policy leads_read_own on public.leads for select using (sender_id = auth.uid());
create policy leads_insert_any on public.leads for insert with check (true);
create policy favorites_self_all on public.favorites for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy saved_searches_self_all on public.saved_searches for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy applications_self_read on public.applications for select using (applicant_id = auth.uid());
create policy applications_self_insert on public.applications for insert with check (applicant_id = auth.uid());
create policy app_docs_self on public.application_documents for all using (exists (select 1 from public.applications a where a.id = application_id and a.applicant_id = auth.uid())) with check (exists (select 1 from public.applications a where a.id = application_id and a.applicant_id = auth.uid()));

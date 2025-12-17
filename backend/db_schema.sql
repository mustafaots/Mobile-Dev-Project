-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.activities (
  post_id integer NOT NULL,
  activity_type character varying NOT NULL,
  requirements jsonb DEFAULT '{}'::jsonb,
  CONSTRAINT activities_pkey PRIMARY KEY (post_id),
  CONSTRAINT activities_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id)
);
CREATE TABLE public.bookings (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  post_id integer NOT NULL,
  client_id uuid NOT NULL,
  status USER-DEFINED DEFAULT 'pending'::booking_status,
  booked_at timestamp with time zone DEFAULT now(),
  start_time timestamp with time zone NOT NULL,
  end_time timestamp with time zone NOT NULL,
  CONSTRAINT bookings_pkey PRIMARY KEY (id),
  CONSTRAINT bookings_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id),
  CONSTRAINT bookings_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.locations (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  wilaya character varying NOT NULL,
  city character varying NOT NULL,
  address text NOT NULL,
  latitude numeric NOT NULL CHECK (latitude >= '-90'::integer::numeric AND latitude <= 90::numeric),
  longitude numeric NOT NULL CHECK (longitude >= '-180'::integer::numeric AND longitude <= 180::numeric),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT locations_pkey PRIMARY KEY (id)
);
CREATE TABLE public.post_images (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  post_id integer NOT NULL,
  public_id character varying NOT NULL,
  secure_url text NOT NULL,
  width integer,
  height integer,
  format character varying,
  bytes integer,
  sort_order integer DEFAULT 0,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT post_images_pkey PRIMARY KEY (id),
  CONSTRAINT post_images_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id)
);
CREATE TABLE public.posts (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  owner_id uuid NOT NULL,
  category USER-DEFINED NOT NULL,
  title character varying NOT NULL,
  description text,
  price numeric NOT NULL CHECK (price >= 0::numeric),
  location_id integer NOT NULL,
  is_paid boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  status USER-DEFINED DEFAULT 'draft'::post_status,
  availability text DEFAULT '[]'::text,
  CONSTRAINT posts_pkey PRIMARY KEY (id),
  CONSTRAINT posts_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(user_id),
  CONSTRAINT posts_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id)
);
CREATE TABLE public.reports (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  reporter_id uuid NOT NULL,
  reported_post_id integer,
  reported_user_id uuid,
  reason USER-DEFINED NOT NULL,
  description text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT reports_pkey PRIMARY KEY (id),
  CONSTRAINT reports_reported_user_id_fkey FOREIGN KEY (reported_user_id) REFERENCES public.users(user_id),
  CONSTRAINT reports_reporter_id_fkey FOREIGN KEY (reporter_id) REFERENCES public.users(user_id),
  CONSTRAINT reports_reported_post_id_fkey FOREIGN KEY (reported_post_id) REFERENCES public.posts(id)
);
CREATE TABLE public.reviews (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  post_id integer NOT NULL,
  reviewer_id uuid NOT NULL,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT reviews_pkey PRIMARY KEY (id),
  CONSTRAINT reviews_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id),
  CONSTRAINT reviews_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.stays (
  post_id integer NOT NULL,
  stay_type character varying NOT NULL CHECK (stay_type::text = ANY (ARRAY['apartment'::character varying, 'villa'::character varying, 'room'::character varying, 'house'::character varying, 'chalet'::character varying, 'other'::character varying]::text[])),
  area double precision CHECK (area > 0::double precision),
  bedrooms integer CHECK (bedrooms >= 0),
  CONSTRAINT stays_pkey PRIMARY KEY (post_id),
  CONSTRAINT stays_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id)
);
CREATE TABLE public.subscriptions (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  subscriber_id uuid NOT NULL,
  plan USER-DEFINED NOT NULL DEFAULT 'free'::subscription_plan,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT subscriptions_pkey PRIMARY KEY (id),
  CONSTRAINT subscriptions_subscriber_id_fkey FOREIGN KEY (subscriber_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.users (
  user_id uuid NOT NULL,
  first_name character varying,
  last_name character varying,
  is_verified boolean DEFAULT false,
  is_suspended boolean DEFAULT false,
  CONSTRAINT users_pkey PRIMARY KEY (user_id),
  CONSTRAINT users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.vehicles (
  post_id integer NOT NULL,
  vehicle_type character varying NOT NULL CHECK (vehicle_type::text = ANY (ARRAY['car'::character varying, 'bicycle'::character varying, 'motorcycle'::character varying, 'boat'::character varying, 'scooter'::character varying, 'other'::character varying]::text[])),
  model character varying,
  year integer,
  fuel_type character varying CHECK (fuel_type::text = ANY (ARRAY['gasoline'::character varying, 'diesel'::character varying, 'electric'::character varying, 'hybrid'::character varying]::text[])),
  transmission boolean DEFAULT false,
  seats integer,
  features jsonb DEFAULT '[]'::jsonb,
  CONSTRAINT vehicles_pkey PRIMARY KEY (post_id),
  CONSTRAINT vehicles_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id)
);
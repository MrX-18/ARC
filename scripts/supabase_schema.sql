-- ====================================================================
-- ARC MASTER POSTGRESQL / SUPABASE DATABASE SCHEMA
-- Generated for ARC Application - Phase 2 Backend Deployment
-- ====================================================================

-- Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. PROFILES TABLE (Extends auth.users or standalone users)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    display_name TEXT NOT NULL,
    avatar_url TEXT,
    primary_goal TEXT,
    daily_commitment TEXT,
    weekly_frequency TEXT,
    experience_level TEXT,
    onboarding_completed BOOLEAN DEFAULT FALSE,
    is_guest BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 2. USER ARCS TABLE
CREATE TABLE IF NOT EXISTS public.user_arcs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    arc_template_id TEXT NOT NULL,
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    description TEXT,
    duration_days INT NOT NULL DEFAULT 30,
    status TEXT NOT NULL DEFAULT 'NOT_STARTED', -- ACTIVE, COMPLETED, PAUSED, NOT_STARTED
    current_day INT NOT NULL DEFAULT 1,
    progress FLOAT NOT NULL DEFAULT 0.0,
    difficulty TEXT,
    daily_commitment TEXT,
    weekly_frequency TEXT,
    cover_image TEXT,
    rules JSONB DEFAULT '[]'::jsonb,
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 3. ARC MISSIONS TABLE
CREATE TABLE IF NOT EXISTS public.arc_missions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    arc_id UUID REFERENCES public.user_arcs(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- workout, hydration, sleep, study, reading
    frequency TEXT NOT NULL DEFAULT 'DAILY',
    completed BOOLEAN DEFAULT FALSE,
    target_value FLOAT,
    unit TEXT,
    category TEXT,
    scheduled_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 4. ACTIVITY LOGS TABLE
CREATE TABLE IF NOT EXISTS public.activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    arc_id UUID REFERENCES public.user_arcs(id) ON DELETE CASCADE NOT NULL,
    mission_id UUID REFERENCES public.arc_missions(id) ON DELETE SET NULL,
    type TEXT NOT NULL,
    value FLOAT NOT NULL,
    unit TEXT NOT NULL,
    note TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 5. REFLECTIONS TABLE
CREATE TABLE IF NOT EXISTS public.reflections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    arc_id UUID REFERENCES public.user_arcs(id) ON DELETE CASCADE NOT NULL,
    arc_title TEXT NOT NULL,
    what_changed TEXT,
    most_proud_of TEXT,
    hardest_part TEXT,
    do_differently TEXT,
    notes TEXT,
    date TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 6. ACHIEVEMENTS TABLE
CREATE TABLE IF NOT EXISTS public.achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    achievement_key TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    unlocked BOOLEAN DEFAULT FALSE,
    unlocked_at TIMESTAMP WITH TIME ZONE
);

-- INDEXES FOR PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_user_arcs_user ON public.user_arcs(user_id);
CREATE INDEX IF NOT EXISTS idx_arc_missions_user_date ON public.arc_missions(user_id, scheduled_date);
CREATE INDEX IF NOT EXISTS idx_activity_logs_user_arc ON public.activity_logs(user_id, arc_id);

-- ROW LEVEL SECURITY (RLS) POLICIES
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_arcs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.arc_missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reflections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;

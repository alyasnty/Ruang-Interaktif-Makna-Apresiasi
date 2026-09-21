-- RIMA DATABASE SCHEMA
-- Jalankan seluruh file ini di Supabase Dashboard > SQL Editor.
-- Setelah itu buat akun admin di Authentication > Users.

create extension if not exists pgcrypto;

create table if not exists public.rima_poems (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  content text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.rima_media (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  media_type text not null check (media_type in ('audio','video')),
  level integer not null check (level between 1 and 6),
  file_path text,
  public_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.rima_quizzes (
  id uuid primary key default gen_random_uuid(),
  question text not null,
  options jsonb not null,
  correct_index integer not null check (correct_index between 0 and 3),
  explanation text,
  level integer not null check (level between 1 and 6),
  created_at timestamptz not null default now()
);

create table if not exists public.rima_students (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  score integer not null default 0,
  completed_levels jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.rima_poems enable row level security;
alter table public.rima_media enable row level security;
alter table public.rima_quizzes enable row level security;
alter table public.rima_students enable row level security;

-- Public siswa: hanya boleh membaca konten pembelajaran.
create policy "public can read poems" on public.rima_poems for select to anon, authenticated using (true);
create policy "public can read media" on public.rima_media for select to anon, authenticated using (true);
create policy "public can read quizzes" on public.rima_quizzes for select to anon, authenticated using (true);

-- Demo awal: authenticated users dapat membaca ranking/progress.
create policy "authenticated can read students" on public.rima_students for select to authenticated using (true);

-- Admin write policies.
-- Cara sederhana untuk prototype: semua authenticated user dianggap admin.
-- Untuk produksi, tambahkan role/claims khusus admin.
create policy "authenticated can insert poems" on public.rima_poems for insert to authenticated with check (true);
create policy "authenticated can delete poems" on public.rima_poems for delete to authenticated using (true);

create policy "authenticated can insert media" on public.rima_media for insert to authenticated with check (true);
create policy "authenticated can delete media" on public.rima_media for delete to authenticated using (true);

create policy "authenticated can insert quizzes" on public.rima_quizzes for insert to authenticated with check (true);
create policy "authenticated can delete quizzes" on public.rima_quizzes for delete to authenticated using (true);

create policy "authenticated can insert students" on public.rima_students for insert to authenticated with check (true);
create policy "authenticated can update students" on public.rima_students for update to authenticated using (true) with check (true);

-- Storage bucket untuk audio/video.
insert into storage.buckets (id, name, public)
values ('rima-media','rima-media',true)
on conflict (id) do nothing;

create policy "public can view rima media"
on storage.objects for select to anon, authenticated
using (bucket_id = 'rima-media');

create policy "authenticated can upload rima media"
on storage.objects for insert to authenticated
with check (bucket_id = 'rima-media');

create policy "authenticated can delete rima media"
on storage.objects for delete to authenticated
using (bucket_id = 'rima-media');

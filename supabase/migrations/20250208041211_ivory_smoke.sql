/*
  # Initial Schema Setup
  
  1. New Tables
    - `profiles`
      - `id` (uuid, primary key)
      - `created_at` (timestamp)
      - `email` (text)
      - `name` (text)
      
  2. Security
    - Enable RLS on `profiles` table
    - Add policies for authenticated users to:
      - Read their own profile
      - Update their own profile
*/

CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz DEFAULT now(),
  email text UNIQUE NOT NULL,
  name text,
  CONSTRAINT fk_auth FOREIGN KEY (id) REFERENCES auth.users (id) ON DELETE CASCADE
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own profile"
  ON profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

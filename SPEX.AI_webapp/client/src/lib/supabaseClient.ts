import { createClient } from '@supabase/supabase-js';

// 1. We use import.meta.env for Vite (Frontend)
// 2. We access the VITE_ prefixed variables
const supabaseUrl = import.meta.env.VITE_SUPABASE_PROJECT_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

// Debugging: Log these to console to see if they are being read (Remove later)
// console.log("Supabase URL:", supabaseUrl);
// console.log("Supabase Key:", supabaseAnonKey ? "Found" : "Missing");

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error("Supabase URL and Anon Key must be set in your environment variables. Check your .env file has VITE_ prefix.");
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Define the shape of our Chat Session data
export interface ChatSession {
  id: string;
  collection_name: string;
  domain_url: string;
  messages: any[];
  created_at: string;
}
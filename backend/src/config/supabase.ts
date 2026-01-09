import { createClient } from '@supabase/supabase-js';
import env from './env';

const supabase = createClient(env.supabaseUrl, env.supabaseServiceRoleKey, {
  auth: { persistSession: false },
  db: { schema: 'public' },
});

export default supabase;

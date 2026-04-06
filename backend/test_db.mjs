import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.join(__dirname, '.env') });

import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

const supabase = createClient(supabaseUrl, supabaseKey);

async function scanDatabase() {
    console.log("Testing connection to:", supabaseUrl);
    
    // We can try fetching one row from a generic known potential table, 
    // or we can test by calling an arbitrary non-existent table to see if it responds correctly.
    // However, the best generic test in Supabase to see if credentials work without knowing schema is to just grab a random table or call RPC.
    // A trick to get all tables when using service_role is to query the information_schema using REST or just do a generic postgREST call.
    
    // Let's just do a generic fetch that limits to 1 to see if we get a valid auth response
    const { data: anyData, error: anyError } = await supabase.from('users').select('*').limit(1);
    
    if (anyError && anyError.code !== 'PGRST116' && anyError.code !== '42P01') {
        // 42P01 is relation does not exist, which still means auth worked!
        console.error("Connection Error:", anyError);
    } else {
        console.log("Connection successful! Authenticated with service_role successfully.");
        if (anyError && anyError.code === '42P01') {
            console.log("(Note: 'users' table doesn't exist, but authentication went through perfectly.)");
        } else {
            console.log("Successfully fetched from 'users' table.");
        }
    }
}

scanDatabase();

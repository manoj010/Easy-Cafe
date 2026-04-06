import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.join(__dirname, '.env') });

import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

const supabase = createClient(supabaseUrl, supabaseKey, {
    auth: {
        autoRefreshToken: false,
        persistSession: false
    }
});

async function setupAuth() {
    console.log("Creating superadmin via Admin API...");
    // 1. Create or get the Super Admin User
    const { data, error } = await supabase.auth.admin.createUser({
        email: 'superadmin@easycafe.com',
        password: 'superadmin',
        email_confirm: true,
        user_metadata: {
            username: 'superadmin',
            role: 'admin'
        }
    });

    if (error) {
        if (error.message.includes("already exist")) {
            console.log("Superadmin user already exists. We will try fetching the ID to update metadata...");
        } else {
            console.error("Error creating superadmin:", error.message);
            return;
        }
    } else {
        console.log("Successfully created superadmin with ID:", data.user.id);
    }
}

setupAuth();

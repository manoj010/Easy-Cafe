import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.join(__dirname, '.env') });

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { createClient } from "@supabase/supabase-js";
import { z } from "zod";

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY; // Service role key or anon key depending on your access needs

if (!supabaseUrl || !supabaseKey) {
  console.error("Error: SUPABASE_URL and SUPABASE_KEY environment variables are required.");
  process.exit(1);
}

// Initialize Supabase Client
const supabase = createClient(supabaseUrl, supabaseKey);

// Create MCP Server
const server = new McpServer({
  name: "supabase-mcp",
  version: "1.0.0",
});

// Tool: Select from table
server.tool(
  "select_from_table",
  "Select all columns from a specified Supabase table with an optional limit.",
  {
    table: z.string().describe("The name of the table to select from"),
    limit: z.number().optional().default(10).describe("The maximum number of rows to return"),
  },
  async ({ table, limit }) => {
    try {
      const { data, error } = await supabase.from(table).select('*').limit(limit);
      
      if (error) {
        return { content: [{ type: "text", text: `Error selecting from ${table}: ${error.message}` }], isError: true };
      }
      
      return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
    } catch (err) {
      return { content: [{ type: "text", text: `Exception: ${err.message}` }], isError: true };
    }
  }
);

// Tool: Execute SQL query via RPC (Requires an execute_sql function in your Supabase DB)
server.tool(
  "query_database",
  "Execute raw SQL query using a custom RPC endpoint on Supabase. Note: this requires an RPC function named 'execute_sql' taking a 'query' string parameter.",
  { 
    sql: z.string().describe("The SQL query string to execute") 
  },
  async ({ sql }) => {
    try {
        const { data, error } = await supabase.rpc("execute_sql", { query: sql });
        
        if (error) {
            return {
                content: [{ type: "text", text: `Supabase RPC Error: ${error.message}\nMake sure you have an 'execute_sql' Postgres function created in your database.` }],
                isError: true,
            };
        }
        
        return {
            content: [{ type: "text", text: JSON.stringify(data, null, 2) }]
        };
    } catch (err) {
        return {
            content: [{ type: "text", text: `Exception: ${err.message}` }],
            isError: true,
        };
    }
  }
);

async function main() {
    const transport = new StdioServerTransport();
    await server.connect(transport);
    console.error("Supabase MCP server is now running and connected via stdio!");
}

main().catch(err => {
    console.error("Fatal error starting MCP string:", err);
    process.exit(1);
});

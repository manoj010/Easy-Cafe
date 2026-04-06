require('dotenv').config();
const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');
const { createClient } = require('@supabase/supabase-js');

// Initialize Supabase Client
const supabaseUrl = process.env.SUPABASE_URL || 'https://zrmsorelryvvjoioaahu.supabase.co';
const supabaseKey = process.env.SERVICE_ROLE; // From Management API fetch
const supabase = createClient(supabaseUrl, supabaseKey);

const server = new Server(
  { name: 'supabase-mcp', version: '1.0.0' },
  { capabilities: { tools: {} } }
);

// Tool to execute SQL (Requires a custom Postgres RPC function if using supabase-js)
// Note: This is an example. To run DDL, you'd usually use the DB connection.
server.setRequestHandler('tools/list', async () => ({
  tools: [
    {
      name: 'query_menu_items',
      description: 'Fetch all menu items from the Supabase database.',
      inputSchema: { type: 'object', properties: {} }
    },
    {
      name: 'upsert_menu_item',
      description: 'Add or update a menu item.',
      inputSchema: {
        type: 'object',
        properties: {
          name: { type: 'string' },
          price: { type: 'number' },
          description: { type: 'string' },
          category: { type: 'string' },
          image_url: { type: 'string' },
          in_stock: { type: 'boolean' }
        },
        required: ['name', 'price', 'category']
      }
    }
  ]
}));

server.setRequestHandler('tools/call', async (request) => {
  const { name, arguments: args } = request.params;
  
  if (name === 'query_menu_items') {
    const { data, error } = await supabase.from('menu_items').select('*');
    if (error) return { content: [{ type: 'text', text: `Error: ${error.message}` }], isError: true };
    return { content: [{ type: 'text', text: JSON.stringify(data, null, 2) }] };
  }
  
  if (name === 'upsert_menu_item') {
    const { name, price, description, category, image_url, in_stock } = args;
    const { data, error } = await supabase
      .from('menu_items')
      .upsert({ name, price, description, category, image_url, in_stock })
      .select();
    if (error) return { content: [{ type: 'text', text: `Error: ${error.message}` }], isError: true };
    return { content: [{ type: 'text', text: `Success: ${JSON.stringify(data)}` }] };
  }

  throw new Error(`Unknown tool: ${name}`);
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Supabase MCP Server running on stdio');
}

main().catch(console.error);

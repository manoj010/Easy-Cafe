const { Client } = require('pg');
const fs = require('fs');

async function runSql() {
  // Using IPv4-compatible Supavisor Pooler on port 6543
  // Removed ?sslmode=require from string to handle in config
  const connectionString = 'postgresql://postgres.zrmsorelryvvjoioaahu:easycafe@@104@aws-0-us-east-1.pooler.supabase.com:6543/postgres';
  
  const client = new Client({
    connectionString: connectionString,
    ssl: { rejectUnauthorized: false }
  });

  try {
    console.log('Attempting to connect to Supavisor IPv4 Pooler...');
    await client.connect();
    console.log('CONNECTED successfully!');
    
    const sql = fs.readFileSync('tmp/create_menu_table.sql', 'utf8');
    await client.query(sql);
    
    console.log('SUCCESS: Menu items table and policies created!');
  } catch (err) {
    console.error('FAILED to execute SQL:', err);
    process.exit(1);
  } finally {
    try { await client.end(); } catch (e) {}
  }
}

runSql();

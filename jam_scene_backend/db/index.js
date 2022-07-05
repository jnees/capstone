/* 
Node PostgreSQL connection

Reference:
Derived from node-postgres package documentation found here
& on the following Features pages:
https://node-postgres.com/features/connecting
*/
const { Pool, Client } = require("pg");
require("dotenv").config();

const pool = new Pool({
  user: process.env.USER,
  host: process.env.HOST,
  database: process.env.DATABASE,
  password: process.env.PASSWORD,
  port: process.env.PORT,
});

const getUsers = (req, res) => {
  const query = "SELECT * FROM users";

  (async () => {
    try {
      const client = await pool.connect();
      const response = await client.query(query);
      res.status(200).json(response.rows);
    } catch (err) {
      console.error(err);
    }
  })();
};

module.exports = {
  getUsers,
};

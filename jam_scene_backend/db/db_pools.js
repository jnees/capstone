require("dotenv").config();
const { Pool } = require("pg");

// const pool = new Pool({
//   connectionString: process.env.DATABASE_URL,
//   ssl:
//   {
//     rejectUnauthorized: false
//   }
// });

const pool = (() => {
  if (process.env.NODE_ENV !== "production") {
    return new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: false
    });
  } else {
    return new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: {
        rejectUnauthorized: false
      }
    });
  }
})();

module.exports = pool;
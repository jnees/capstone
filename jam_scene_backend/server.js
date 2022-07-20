const make_app = require("./app.js");
const db = require("./db/db_pool.js");

/* 
Heroku hosting setup

Reference:
Derived from the Heroku Deployment documentation found here:
https://devcenter.heroku.com/articles/preparing-a-codebase-for-heroku-deployment
*/
let port = process.env.PORT;

const app = make_app(db);

app.listen(port, () => {
  console.log(`Listening on port: ${port}`);
});

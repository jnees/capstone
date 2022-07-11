const app = require("./app.js");

/* 
Heroku hosting setup

Reference:
Derived from the Heroku Deployment documentation found here:
https://devcenter.heroku.com/articles/preparing-a-codebase-for-heroku-deployment
*/
let port = process.env.PORT;

app.listen(port, () => {
  console.log(`Listening on post: ${port}`);
});

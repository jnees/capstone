const express = require("express");

const app = express();

// Add req.body to all requests
app.use(express.json());
app.use(express.urlencoded({ extended: true}));

app.get("/", (req, res) => {
    res.send("Hello World!")
});

const port = 8000;
app.listen(port, () => {
    console.log(`Listening on post: ${port}`);
});
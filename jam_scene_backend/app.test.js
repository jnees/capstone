
const request = require("supertest");
const app = require("./app.js");

/*
Testing server API

Reference:
Method based on Youtube tutorial from Sam Meech-Ward:
https://youtu.be/FKnzS_icp20
*/

describe("GET /", () => {
  test("should respond with > 200 status code", async () => {
    const response = await request(app).get("/");
    expect(response.statusCode).toBe(200);
  });
});


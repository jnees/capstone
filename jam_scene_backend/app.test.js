
const request = require("supertest");
const app = require("./app.js");

describe("GET /", () => {
  test("should respond with > 200 status code", async () => {
    const response = await request(app).get("/");
    expect(response.statusCode).toBe(200);
  });
});


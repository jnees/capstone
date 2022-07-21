
const request = require("supertest");
const make_app = require("./app.js");

/*
Testing server API

Reference:
Method based on Youtube tutorial from Sam Meech-Ward:
https://youtu.be/FKnzS_icp20
*/

const getAllUsers = jest.fn();
const getUserObjById = jest.fn();
const getInstByUserId = jest.fn();
const deleteUserObj = jest.fn();
const addNewUserObj = jest.fn();
const addNewUserInstRelation = jest.fn();
const updateUserObj = jest.fn();
const deleteUserInstRelation = jest.fn();
const getSearchInfo = jest.fn();

const app = make_app({
  getAllUsers,
  getUserObjById,
  getInstByUserId,
  deleteUserObj,
  addNewUserObj,
  addNewUserInstRelation,
  updateUserObj,
  deleteUserInstRelation,
  getSearchInfo
});

describe("GET /users", () => {
  beforeEach(() => {
    getSearchInfo.mockReset();
  });

  test("should respond with 200", async () => {
    const result = await request(app).get("/users");
    expect(result.statusCode).toBe(200);
  });
  test("should call getSearchInfo once", async () => {
    await request(app).get("/users").send({
      "zip": "98101",
      "instrument": "Bass",
      "days": { "sun": false, "mon": true, "tue": false, "wed": false, "thu": false, "fri": false, "sat": true }
    });
    expect(getSearchInfo.mock.calls.length).toBe(1);
  });
});

describe("PUT /user/:id", () => {
  beforeEach(() => {
    updateUserObj.mockReset();
    deleteUserInstRelation.mockReset();
    addNewUserInstRelation.mockReset();
  });
  test("should respond with 200", async () => {
    const result = await request(app).put("/user/1");
    expect(result.statusCode).toBe(200);
  });
  test("should call updateUserObj once", async () => {
    await request(app).put("/user/1");
    expect(updateUserObj.mock.calls.length).toBe(1);
  });
  test("should call deleteUserInstRelation once", async () => {
    await request(app).put("/user/1");
    expect(deleteUserInstRelation.mock.calls.length).toBe(1);
  });
  test("should call addNewUserInstRelation once", async () => {
    await request(app).put("/user/1");
    expect(addNewUserInstRelation.mock.calls.length).toBe(1);
  });
});

describe("POST /users", () => {
  beforeEach(() => {
    addNewUserObj.mockReset();
    addNewUserInstRelation.mockReset();
  });

  test("should respond with 200", async () => {
    const result = await request(app).post("/users");
    expect(result.statusCode).toBe(200);
  });
  test("should call addNewUserObj once", async () => {
    await request(app).post("/users");
    expect(addNewUserObj.mock.calls.length).toBe(1);
  });
  test("should call addNewUserInstRelation once", async () => {
    await request(app).post("/users");
    expect(addNewUserInstRelation.mock.calls.length).toBe(1);
  });
});

describe("DELETE /user/:id", () => {
  beforeEach(() => {
    deleteUserObj.mockReset();
  });

  test("should respond with 200", async () => {
    const result = await request(app).delete("/user/1");
    expect(result.statusCode).toBe(200);
  });
  test("should call deleteUserObj once", async () => {
    await request(app).delete("/user/1");
    expect(deleteUserObj.mock.calls.length).toBe(1);
  });
});

describe("GET /user/:id", () => {
  beforeEach(() => {
    getUserObjById.mockReset();
    getInstByUserId.mockReset();
  });

  test("should respond with 200", async () => {
    const result = await request(app).get("/user/1");
    expect(result.statusCode).toBe(200);
  });
  test("should call getUserObjById once", async () => {
    await request(app).get("/user/1");
    expect(getUserObjById.mock.calls.length).toBe(1);
  });
  test("should call getInstByUserId once", async () => {
    await request(app).get("/user/1");
    expect(getInstByUserId.mock.calls.length).toBe(1);
  });
});

describe("GET /all_users", () => {
  beforeEach(() => {
    getAllUsers.mockReset();
  });

  test("all_users should return successfully", async () => {
    const result = await request(app).get("/all_users");
    expect(result.statusCode).toBe(200);
    expect(getAllUsers.mock.calls.length).toBe(1);
  });
});

describe("GET /", () => {
  test("should respond with > 200 status code", async () => {
    const response = await request(app).get("/");
    expect(response.statusCode).toBe(200);
  });
});


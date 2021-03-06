"use strict";

const expect = require("chai").expect;
const codecheck = require("codecheck");
const app = codecheck.consoleApp(process.env.APP_COMMAND);
const get = require("./get.js");

describe("Recursive API function", () => {

  it("should throw an error and return an error message string when args are missing", () => {
    return app.codecheck().then( result => {
      let actualResult = result.stdout.join("");
      expect(result.code).to.equal(1, "codecheck CLI should fail with status code 1");
      expect(actualResult).to.be.ok;
      expect(actualResult).to.be.a('string');
    });
  });

  it("properly implements f(0) = 1", () => {
    let seed = "In this case, the seed is not required because the API will never be called.";
    return app.codecheck(seed, 0).then( result => {
      let actualResult = parseInt(result.stdout.join(""));
      expect(result.code).to.equal(0, "codecheck CLI should exit with status code 0");
      expect(actualResult).to.be.equal(1);
    });
  });
  it("properly implements f(2) = 2", () => {
    let seed = "In this case, the seed is not required because the API will never be called.";
    return app.codecheck(seed, 2).then( result => {
      let actualResult = parseInt(result.stdout.join(""));
      expect(result.code).to.equal(0, "codecheck CLI should exit with status code 0");
      expect(actualResult).to.be.equal(2);
    });
  });
  it("properly requests API and returns result of f(1)", () => {
    return get("http://challenge-server.code-check.io/api/recursive/generate?n=1")
    .then((data) => {
      let input = [data.seed, 1];
      let expectedResult = data.result;
      return app.codecheck(...input).then( result => {
        let actualResult = parseInt(result.stdout.join(""));
        expect(result.code).to.equal(0, "codecheck CLI should exit with status code 0");
        expect(actualResult).to.be.equal(expectedResult);
      });
    });
  });
  it("properly requests API and returns result of f(3)", () => {
    return get("http://challenge-server.code-check.io/api/recursive/generate?n=3")
    .then((data) => {
      let input = [data.seed, 3];
      let expectedResult = data.result;
      return app.codecheck(...input).then( result => {
        let actualResult = parseInt(result.stdout.join(""));
        expect(result.code).to.equal(0, "codecheck CLI should exit with status code 0");
        expect(actualResult).to.be.equal(expectedResult);
      });
    });
  });
  it("properly implements recursive functionality and returns result of f(4)", () => {
    return get("http://challenge-server.code-check.io/api/recursive/generate?n=4")
    .then((data) => {
      let input = [data.seed, 4];
      let expectedResult = data.result;
      return app.codecheck(...input).then( result => {
        let actualResult = parseInt(result.stdout.join(""));
        expect(result.code).to.equal(0, "codecheck CLI should exit with status code 0");
        expect(actualResult).to.be.equal(expectedResult);
      });
    });
  });
  it("properly implements recursive functionality and returns result of f(6)", () => {
    return get("http://challenge-server.code-check.io/api/recursive/generate?n=6")
    .then((data) => {
      let input = [data.seed, 6];
      let expectedResult = data.result;
      return app.codecheck(...input).then( result => {
        let actualResult = parseInt(result.stdout.join(""));
        expect(result.code).to.equal(0, "codecheck CLI should exit with status code 0");
        expect(actualResult).to.be.equal(expectedResult);
      });
    });
  });
  it("properly implements cache functionality and returns result of f(20)", () => {
    return get("http://challenge-server.code-check.io/api/recursive/generate?n=20")
    .then((data) => {
      let input = [data.seed, 20];
      let expectedResult = data.result;
      return app.codecheck(...input).then( result => {
        let actualResult = parseInt(result.stdout.join(""));
        expect(result.code).to.equal(0, "codecheck CLI should exit with status code 0");
        expect(actualResult).to.be.equal(expectedResult);
      });
    });
  });
  it("properly implements cache functionality and returns result of f(30)", () => {
    return get("http://challenge-server.code-check.io/api/recursive/generate?n=30")
    .then((data) => {
      let input = [data.seed, 30];
      let expectedResult = data.result;
      return app.codecheck(...input).then( result => {
        let actualResult = parseInt(result.stdout.join(""));
        expect(result.code).to.equal(0, "codecheck CLI should exit with status code 0");
        expect(actualResult).to.be.equal(expectedResult);
      });
    });
  });
  it("properly implements cache functionality and returns result of f(40)", () => {
    return get("http://challenge-server.code-check.io/api/recursive/generate?n=40")
    .then((data) => {
      let input = [data.seed, 40];
      let expectedResult = data.result;
      return app.codecheck(...input).then( result => {
        let actualResult = parseInt(result.stdout.join(""));
        expect(result.code).to.equal(0, "codecheck CLI should exit with status code 0");
        expect(actualResult).to.be.equal(expectedResult);
      });
    });
  });
});

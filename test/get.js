const http = require("http");

module.exports = (uri) => {
  let data = "";
  return new Promise((resolve, reject) => {
    http.get(uri, (res) => {
      const statusCode = res.statusCode;
      const contentType = res.headers['content-type'];

      if (statusCode !== 200) {
        reject("request failed with status code " + statusCode)
      } else if (!/^application\/json/.test(contentType)) {
        reject("invalid response type" + contentType);
      } else {
        res.on("data", (chunk) => {
          data += chunk;
        });
        res.on("end", () => {
          resolve(JSON.parse(data));
        });
      }
    });
  });
};

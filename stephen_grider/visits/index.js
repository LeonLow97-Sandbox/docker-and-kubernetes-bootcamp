const express = require("express");
const redis = require("redis");
const process = require("process");

const app = express();

// Specify where redis server is running on
const client = redis.createClient({
  host: "redis-server",
  port: 6379,
});
client.set("visits", 0);

app.get("/", (req, res) => {
  process.exit(1); // 0 - exited and everything is OK, 1,2,3 - exited with error
  client.get("visits", (err, visits) => {
    res.send("Number of visits is " + visits);
    client.set("visits", parseInt(visits) + 1);
  });
});

app.listen(8081, () => {
  console.log("Listening on port 8081");
});

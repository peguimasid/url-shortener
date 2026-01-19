import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = "http://localhost:9999"

export const options = {
  stages: [
    // Ramp-up: gradually increase load
    { duration: "30s", target: 50 },
    { duration: "30s", target: 100 },
    { duration: "30s", target: 200 },

    // Stress: push the system to its limits
    { duration: "1m", target: 500 },
    { duration: "1m", target: 1000 },

    // Spike: sudden extreme load
    { duration: "30s", target: 2000 },

    // Recovery: scale down to see how system recovers
    { duration: "30s", target: 100 },
    { duration: "30s", target: 0 },
  ],
  thresholds: {
    http_req_duration: ["p(95)<500", "p(99)<1000"],
    http_req_failed: ["rate<0.01"],
  },
};

const main = () => {
  const res = http.get(`${BASE_URL}/api/health-check`);

  check(res, {
    "status is 200": (r) => r.status === 200,
    "response time < 200ms": (r) => r.timings.duration < 200,
  });

  sleep(0.1);
}

export default main

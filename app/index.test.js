import { describe, it, expect, afterAll } from "bun:test";
import server from "./index.js";

afterAll(() => server.stop());

describe("HTTP Server", () => {
    it("GET / should return 200 and message field", async () => {
        const res = await fetch(`${server.url}/`);
        const body = await res.json();

        expect(res.status).toBe(200);
        expect(body.message).toBeDefined();
    });

    it("GET /health should return 200 and healthy status", async () => {
        const res = await fetch(`${server.url}/health`);
        const body = await res.json();

        expect(res.status).toBe(200);
        expect(body).toEqual({ status: "healthy" });
    });
});

const PORT = process.env.PORT || 3000;
const APP_ENV = process.env.APP_ENV || "dev";

const server = Bun.serve({
    port: PORT,
    fetch(req) {
        const { pathname } = new URL(req.url);

        if (pathname === "/") {
            return Response.json({
                message: "ok",
                env: APP_ENV,
            });
        }

        if (pathname === "/health") {
            return Response.json({
                status: "healthy"
            });
        }

        return new Response("Not Found", { status: 404 });
    },
});

console.log(`Server running on port ${PORT} in ${APP_ENV} mode`);

export default server;
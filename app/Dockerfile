FROM oven/bun:alpine

WORKDIR /app

COPY package.json index.js ./

ENV PORT=3000
EXPOSE 3000

USER bun

CMD ["bun", "index.js"]

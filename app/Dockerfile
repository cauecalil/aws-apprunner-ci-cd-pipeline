FROM oven/bun:alpine

WORKDIR /app

COPY package.json index.js ./

ENV PORT=3000
EXPOSE 3000

CMD ["bun", "index.js"]

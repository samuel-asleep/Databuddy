FROM oven/bun:1

WORKDIR /app
COPY . .

RUN bun install \
 && bun run --cwd packages/sdk build \
 && bun run --cwd apps/dashboard build

EXPOSE 3000

CMD ["bun", "run", "--cwd", "apps/dashboard", "start", "-p", "3000"]

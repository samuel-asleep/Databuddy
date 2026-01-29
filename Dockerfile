FROM oven/bun:1

WORKDIR /app
COPY . .
ARG REDIS_URL
ENV REDIS_URL=$REDIS_URL
ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL
RUN bun install \
 && bun run --cwd packages/sdk build \
 && bun run --cwd apps/dashboard build

EXPOSE 3000

CMD ["bun", "run", "--cwd", "apps/dashboard", "start", "-p", "3000"]

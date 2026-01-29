# Databuddy

## Overview

Databuddy is a comprehensive, privacy-first analytics and data management platform. It provides real-time analytics, user behavior tracking, uptime monitoring, and LLM observability. The platform is built as a monorepo using Turborepo with Bun as the package manager, featuring a Next.js dashboard, multiple backend services, and publishable SDKs.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Monorepo Structure

The project uses Turborepo to manage a monorepo with two main directories:
- `apps/` - Deployable applications
- `packages/` - Shared libraries and SDKs

### Applications

**Dashboard (`apps/dashboard`)**: Next.js 16 application serving as the main user interface. Uses React 19, Tailwind CSS 4, shadcn/ui components, and React Query for data fetching. Communicates with the API via oRPC.

**API (`apps/api`)**: Elysia-based HTTP server handling authentication, analytics queries, and AI features. Uses oRPC for type-safe procedure definitions. Integrates with Vercel AI SDK for LLM features.

**Basket (`apps/basket`)**: Event ingestion service that receives analytics events from the tracker SDK. Processes events through Kafka and stores them in ClickHouse.

**Links (`apps/links`)**: URL shortener and redirect service with click tracking.

**Uptime (`apps/uptime`)**: Uptime monitoring service that checks website availability and sends notifications.

**Docs (`apps/docs`)**: Documentation site built with Fumadocs and Next.js.

### Core Packages

**Database (`packages/db`)**: Drizzle ORM with PostgreSQL for relational data and ClickHouse for analytics time-series data. Uses Neon serverless driver for edge compatibility.

**Authentication (`packages/auth`)**: Better Auth implementation with OAuth providers (Google, GitHub), two-factor authentication, and organization support.

**Redis (`packages/redis`)**: ioredis-based caching layer with rate limiting, cache invalidation, and a custom Drizzle cache adapter.

**RPC (`packages/rpc`)**: oRPC server definitions shared between API and dashboard for end-to-end type safety.

**SDK (`packages/sdk`)**: Published npm package providing React/Vue components and core tracking functionality for end users.

**Tracker (`packages/tracker`)**: Browser scripts deployed to Bunny CDN for lightweight client-side analytics collection.

**AI (`packages/ai`)**: LLM observability wrappers for OpenAI, Anthropic, and Vercel AI SDK.

### Data Flow

1. Browser loads tracker script from CDN
2. Tracker sends events to Basket service
3. Basket validates, enriches (geo, device), and queues events in Kafka
4. Events are batch-inserted into ClickHouse
5. Dashboard queries API, which reads from ClickHouse/PostgreSQL

### Build System

- Turborepo orchestrates builds with proper dependency ordering
- Bun is the package manager and runtime
- unbuild compiles publishable packages (SDK, cache, AI)
- Biome handles linting and formatting via ultracite

## External Dependencies

### Databases
- **PostgreSQL**: User accounts, websites, organizations, settings (via Drizzle ORM)
- **ClickHouse**: Analytics events, pageviews, sessions, LLM call spans
- **Redis**: Caching, rate limiting, session storage, real-time deduplication

### Message Queue
- **Kafka/Redpanda**: Event streaming between Basket and ClickHouse consumers

### Authentication Providers
- Google OAuth
- GitHub OAuth
- Email/password with verification

### Third-Party Services
- **Resend**: Transactional email delivery
- **Bunny.net**: CDN for tracker scripts
- **Autumn**: Usage-based billing
- **MaxMind GeoIP**: IP geolocation for analytics
- **OpenTelemetry**: Distributed tracing to Axiom/custom OTLP endpoints
- **Upstash QStash**: Scheduled job execution for uptime checks

### AI/LLM Providers
- OpenAI
- Anthropic
- Groq
- OpenRouter (multi-provider routing)
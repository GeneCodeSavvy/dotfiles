---
name: hld-design
description: "7-phase High-Level Design framework: clarify requirements, estimate scale, design components, model data, define APIs, deep dive on bottlenecks, and enumerate failure modes. Use for any system design question or production architecture task."
---

## High-Level Design (HLD) Framework

Structured methodology for designing production systems. Works for interview prep and real architecture decisions. Each phase builds on the last — skip none.

### Context

System to design: **$ARGUMENTS**

If no system is provided, ask: "What system are you designing? What's the scale and key constraints?"

---

### Phase 1: Clarify Requirements (5 min)

Never design in a vacuum. Extract:

**Functional requirements** — what the system must do:
- Core user-facing features (list 3-5 specific capabilities)
- What does success look like for the user?

**Non-functional requirements** — how the system must perform:
- Scale: DAU, QPS (reads vs writes), data volume
- Latency: p50/p99 targets (e.g., "search results < 200ms p99")
- Availability: 99.9% (8.7h downtime/year) vs 99.99% (52min/year)
- Consistency: strong vs eventual — where does it matter?
- Durability: what data cannot be lost?

**Constraints and assumptions:**
- Read-heavy or write-heavy? (affects caching and replication strategy)
- Global or regional? (affects latency, data residency, CDN needs)
- Expected growth: 2x in 6 months? 10x in 2 years?

**Out of scope** — explicitly state what you're NOT designing.

---

### Phase 2: Capacity Estimation (5 min)

Back-of-envelope numbers that drive architecture decisions. Quantify before designing.

**Traffic:**
```
DAU = X million
Reads per user per day = Y
Writes per user per day = Z

Read QPS  = DAU × Y / 86,400
Write QPS = DAU × Z / 86,400
Peak QPS  = avg × 3-5x (account for traffic spikes)
```

**Storage:**
```
Object size = X KB (e.g., tweet = ~300 bytes, image = ~200 KB)
Daily writes = Write QPS × 86,400
3-year storage = Daily writes × 365 × 3
```

**Bandwidth:**
```
Inbound  = Write QPS × avg object size
Outbound = Read QPS × avg response size
```

**Cache:**
```
Hot data = 20% of reads hit 80% of data (Pareto)
Cache size = hot data × avg object size
```

State your assumptions explicitly. Numbers don't need to be perfect — they need to inform decisions.

---

### Phase 3: High-Level Components (10 min)

Draw the system as boxes and arrows. For each component, state its role and why it exists.

**Standard components to consider:**

```
[Clients] -> [CDN] -> [Load Balancer] -> [API Gateway]
                                              |
                          +---------+---------+---------+
                          |         |                   |
                     [Service A] [Service B]       [Service C]
                          |         |                   |
                     [Cache]   [Message Queue]    [Search Index]
                          |         |                   |
                     [Primary DB] [Worker]         [Object Store]
                          |
                     [Read Replica]
```

For each service/component, explain:
- What it does (single responsibility)
- Why it's separate (coupling, scaling, failure isolation)
- Technology choice with brief rationale

**Common patterns:**
- Stateless API servers behind a load balancer (horizontal scaling)
- CDN for static assets and geographic distribution
- Message queue to decouple async work from request path
- Read replicas to offload read traffic from primary
- Cache layer (Redis) for hot reads

---

### Phase 4: Data Model (5 min)

Define the core entities and relationships before writing APIs.

For each entity:
- Fields (name, type, constraints)
- Primary key strategy (UUID, auto-increment, composite)
- Indexes needed for query patterns
- Embed vs reference decision (if document store)

**Access pattern analysis:**
```
Query: "Get user by email" -> Index on email (unique)
Query: "Get posts by user, sorted by time" -> Composite index (user_id, created_at DESC)
Query: "Get all comments for a post" -> Index on post_id
```

State the dominant query patterns first, then design the schema to serve them.

---

### Phase 5: API Design (5 min)

Define the external contract. Use REST unless there's a specific reason for GraphQL or gRPC.

For each endpoint:
```
POST /api/v1/users
Authorization: Bearer <token>
Request:  { email, password, displayName }
Response: { id, email, displayName, createdAt }
Errors:   400 (validation), 409 (email taken), 500 (server error)
```

Include:
- Versioning strategy (URL path `/v1/` is simplest)
- Auth mechanism (JWT Bearer, API key, OAuth2)
- Pagination (cursor-based for large/real-time sets, offset for admin views)
- Rate limiting (429 Too Many Requests, include Retry-After header)
- Idempotency keys for write operations that must not double-execute

---

### Phase 6: Deep Dives (10 min)

Pick 2-3 hardest sub-problems and solve them in detail. Common picks:

**Feed generation:**
- Fan-out on write (push) vs fan-out on read (pull)
- Hybrid: push for normal users, pull for celebrities with 10M+ followers

**Search:**
- Inverted index (Elasticsearch) vs full-text in PostgreSQL (pg_trgm)
- Tokenization, stemming, ranking (BM25 vs vector embeddings)

**Notifications (real-time):**
- WebSockets vs Server-Sent Events vs long polling
- Fanout: who gets notified and when

**Media upload:**
- Pre-signed S3 URLs (client uploads directly, bypasses your servers)
- Async transcoding via message queue after upload

**Distributed rate limiting:**
- Token bucket in Redis with atomic Lua script
- Sliding window log vs fixed window counter tradeoffs

---

### Phase 7: Failure Modes (5 min)

Enumerate what can fail and how the system handles it.

| Component | Failure | Detection | Recovery |
|-----------|---------|-----------|----------|
| Primary DB | Crash | Health check + replica lag monitor | Promote replica, update DNS (< 30s) |
| Cache (Redis) | Eviction / miss | Cache hit rate metric | Serve from DB, warm cache async |
| Message queue | Consumer lag | Queue depth metric > threshold | Scale consumers, alert |
| External API | Timeout / 5xx | Circuit breaker (half-open after 30s) | Fallback response or queue for retry |
| API server | Memory leak | RSS growth + OOM kill | Horizontal scaling + auto-restart |

**For each failure: detection -> recovery -> prevention**

Also address:
- Data consistency on partial writes (idempotency, sagas)
- Split-brain scenarios (for distributed state)
- Thundering herd on cache miss (probabilistic early expiration, mutex lock)

---

### Output Format

```
## System Design: [System Name]

### Requirements
**Functional:** ...
**Non-functional:** ...
**Out of scope:** ...

### Capacity Estimates
| Metric | Calculation | Result |
|--------|-------------|--------|

### Architecture Diagram
[ASCII or Mermaid diagram]

### Component Breakdown
| Component | Role | Technology | Rationale |

### Data Model
[Schema with fields, indexes, relationships]

### API Contract
[Key endpoints with request/response]

### Deep Dives
[2-3 detailed sub-problems solved]

### Failure Modes
[Table: component, failure, detection, recovery]

### Tradeoffs
[3-5 explicit tradeoffs made in this design]
```

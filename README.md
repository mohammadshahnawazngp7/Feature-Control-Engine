# Feature Control Engine (Rails API)

A focused, production-minded **feature flag management system** built with Ruby on Rails (API-only).
It enables dynamic feature control without redeployments, with deterministic evaluation and clean separation
between API, domain logic, and persistence.

**What this service provides**
* Global feature toggles
* User-level overrides
* Group-level overrides
* Region-level overrides
* Deterministic evaluation rules (clear precedence)
* Database-backed storage with strong constraints
* Lightweight evaluation with in-memory caching
* High automated test coverage (run specs to verify)

---

# Run It (Copy/Paste)

```bash
bundle install
bundle exec rails db:create db:migrate
bundle exec rails server
```

Run tests:

```bash
bundle exec rspec
```

---

# Purpose of This System

Modern applications need the ability to:

* Release features gradually
* Test features with specific users
* Enable beta functionality
* Roll back features instantly if needed

This system provides a structured and reliable way to manage feature flags.

---

# How Feature Evaluation Works

When checking if a feature is enabled, the system follows this order:

1. **User Override (Highest Priority)**
2. **Group Override**
3. **Region Override**
4. **Global Default Setting**

Example:

* Default = false
* Group override = true
* User override = false

Final result → **false**
(User override takes priority)

This ensures predictable and consistent behavior.

---

# System Design

The project follows clean architecture principles:

* Controllers handle API requests
* Models store data
* Services handle business logic
* Evaluation logic is isolated and deterministic

Key components:

* Feature (global configuration)
* FeatureOverride (user/group/region specific rules)
* MutationService (data modification logic)

---

# Data Structure

Each Feature contains:

* Unique name
* Default state (true/false)
* Optional description

Each Override contains:

* Feature reference
* Override type (user, group, or region)
* Target ID (stored as string to support regions)
* State (true/false)

The system prevents duplicate overrides automatically.

---

# API Endpoints

Base URL: `http://localhost:3000/api/v1`

---

## Feature APIs

### Get All Features
```bash
curl -X GET http://localhost:3000/api/v1/features
```

---

### Get Single Feature
```bash
curl -X GET http://localhost:3000/api/v1/features/1
```

---

### Create Feature
```bash
curl -X POST http://localhost:3000/api/v1/features \
  -H "Content-Type: application/json" \
  -d '{"feature":{"name":"new_dashboard","default_state":true,"description":"Dashboard feature"}}'
```

---

### Update Feature
```bash
curl -X PATCH http://localhost:3000/api/v1/features/1 \
  -H "Content-Type: application/json" \
  -d '{"feature":{"default_state":false}}'
```

---

### Evaluate Feature (Testing Only)
```bash
curl -X GET "http://localhost:3000/api/v1/features/1/evaluate?user_id=1&region=us-east"
```

---


## Feature Override APIs

### Create Override
```bash
curl -X POST http://localhost:3000/api/v1/features/1/overrides \
  -H "Content-Type: application/json" \
  -d '{"feature_override":{"override_type":"user","override_id":1,"state":true}}'
```

---

### Create Region Override
```bash
curl -X POST http://localhost:3000/api/v1/features/1/overrides \
  -H "Content-Type: application/json" \
  -d '{"feature_override":{"override_type":"region","override_id":"us-east","state":true}}'
```

---

### Update Override
```bash
curl -X PATCH http://localhost:3000/api/v1/features/1/overrides/7 \
  -H "Content-Type: application/json" \
  -d '{"feature_override":{"state":false}}'
```

---

### Delete Override
```bash
curl -X DELETE http://localhost:3000/api/v1/features/1/overrides/7
```

---

# Error Handling

The API returns a consistent JSON error format for client-safe responses:

```json
{
  "errors": ["Error message"]
}
```

Common cases handled:

* Feature not found (404)
* Invalid input or validation failures (422)
* Missing parameters (400)
* Duplicate feature or override constraints (422)

---

# Testing

Tests validate:

* Feature creation and updates
* Override logic
* Evaluation priority rules
* Error handling
* Duplicate prevention

To run tests:

```bash
bundle exec rspec
```

---

# Performance & Scalability

The evaluation logic is lightweight and deterministic. Phase 2 adds an in-memory cache for evaluation:

* Evaluations read from `Rails.cache` (memory store in development).
* Cache is invalidated automatically on feature or override changes.
* This avoids extra database I/O on hot paths after the cache is warm.

# Assumptions
* Each user belongs to one group.
* Override types are limited to `user`, `group`, and `region`.
* No environment-specific flags.
* No percentage rollout.

# Tradeoffs
* Kept the API minimal instead of adding complex rollout strategies.
* Prioritized correctness and clarity over advanced distribution (e.g., percentage rollout, env targeting).
* Focused on request-level operations; no background processing.

# What I’d Do Next With More Time
**With 1 more hour**
* Add serializer layer for consistent API responses.
* Add request benchmarks for feature + override endpoints.

**With 1 more day**
* Add caching (in-memory and/or Redis) for high-traffic lookups.
* Add percentage rollouts and environment targeting.
* Add authentication and audit logging.
* Add API documentation (OpenAPI/Swagger).

# Known Limitations / Rough Edges
* No authentication or authorization on API endpoints.
* No support for multiple groups per user.
* No admin dashboard.
* No concurrency locking.
* No bulk override API.
* No historical tracking.

---

#  Strengths of This Solution

✔ Deterministic evaluation logic
✔ Strong uniqueness constraints
✔ Clean service-based architecture
✔ Nested RESTful API design
✔ Centralized error handling
✔ High test coverage
✔ Easily extensible

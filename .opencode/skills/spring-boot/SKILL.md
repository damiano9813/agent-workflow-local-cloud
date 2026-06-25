---
name: spring-boot
description: Use when working on Spring Boot controllers, services, repositories, DTOs, entities, mappers, validation, security, configuration, or tests.
---

# Spring Boot

Before changing backend behavior, inspect relevant:

- Controllers.
- Services.
- Repositories.
- DTOs.
- Entities.
- Mappers.
- Validation.
- Security.
- Configuration.
- Tests.

Keep business logic in the existing service layer patterns. Preserve validation and security behavior unless explicitly changing them.

Prefer targeted tests around controller, service, or repository behavior depending on the change.

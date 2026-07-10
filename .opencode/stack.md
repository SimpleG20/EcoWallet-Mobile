# EcoWallet — Stack Tecnológica

## Mobile (Existente)

| Tecnologia | Versão | Uso |
|---|---|---|
| Flutter | 3.19+ | Framework mobile |
| Dart | >=3.2.0 <4.0.0 | Linguagem |
| BLoC (flutter_bloc) | ^9.1.1 | State management |
| get_it + injectable | ^9.2.0 / ^2.7.1 | Injeção de dependência |
| sqflite | ^2.4.2 | Banco local offline-first |
| fpdart | ^1.2.0 | Either/Left/Right para erros tipados |
| go_router | ^14.0.0 | Navegação com guards |
| mocktail | ^1.0.4 | Testes |

## Backend (Planejado — Fase 1)

| Tecnologia | Versão | Uso |
|---|---|---|
| **Go** | 1.22+ | Linguagem backend |
| **Fiber** | v3 | HTTP router (substitui chi) |
| **pgx** | v5 | Driver PostgreSQL |
| **sqlc** | latest | Geração de queries tipadas |
| **Goose** | latest | Migrations de banco |
| **PostgreSQL** | 16 | Banco relacional |
| **Redis** | 7 | Cache/sessões (opcional Fase 1) |
| **Protobuf** | proto3 | Contratos de API |
| **JWT** | — | Autenticação (golang-jwt) |
| **Docker** | 24+ | Containerização |
| **Docker Compose** | v2 | Ambiente local |

## Infraestrutura (Planejada — Fases Futuras)

| Tecnologia | Uso |
|---|---|
| Kafka/Redpanda | Event bus (Fase 3) |
| AWS ECS/Fargate | Deploy (Fase 4) |
| Terraform | Infra as code (Fase 4) |
| Prometheus/Grafana | Observabilidade (Fase 4) |
| GitHub Actions | CI/CD (Fase 4) |

## Ferramentas de Desenvolvimento

| Ferramenta | Uso |
|---|---|
| Makefile | Automação local |
| Air (cosmtrek/air) | Hot reload Go |
| Bruno/Postman | Testes de API |
| protoc | Compilador Protobuf |
| golangci-lint | Linter Go |
| testcontainers-go | Testes de integração |

## Versões Mínimas

- Go: 1.22+
- Docker: 24+
- Docker Compose: v2
- PostgreSQL: 16
- protoc: 3.21+

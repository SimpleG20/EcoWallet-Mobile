# EcoWallet — Regras de Desenvolvimento

## Gerais

1. **Plan-first**: Toda tarefa não-trivial deve começar com um plano no `thoughts/plans/` antes da execução.
2. **Portfolio-ready**: Todo código deve ser documentado e testado como se fosse para um recrutador ler.
3. **Commits semânticos**: Usar conventional commits (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `chore:`).
4. **Testes obrigatórios**: Toda função pública deve ter teste unitário.

## Go (Backend)

1. **Router**: Usar **Fiber v3** (NUNCA chi). O plano de evolução original mencionava chi, mas a decisão foi trocar para Fiber.
2. **Estrutura**: Clean Architecture no formato `internal/{domain}/` com handlers, services, repositories.
3. **Config**: Toda configuração via variáveis de ambiente com `.env.example` documentado.
4. **Database**: pgx + sqlc para queries tipadas. Goose para migrations.
5. **Protobuf**: Contratos em `api/proto/`, código gerado em `pkg/protobuf/`.
6. **Logs**: Log estruturado com zerolog ou slog.
7. **Erros**: Erros tipados e consistentes em todas as camadas.
8. **Middlewares**: Recovery, Logger, CORS, Auth JWT, Rate Limiting.

## Flutter (Mobile)

1. **Arquitetura**: Feature-First Clean Architecture (Domain → Data → Presentation).
2. **State Management**: BLoC obrigatório para lógica de negócio.
3. **DI**: get_it + injectable.
4. **Testes**: mocktail + bloc_test.
5. **Offline-first**: SQLite como fonte local de verdade. Sincronização via fila com retry.
6. **Protobuf**: Código gerado para Dart a partir dos `.proto` compartilhados.

## Docker

1. **Multi-stage**: Sempre usar Dockerfile multi-stage para imagem final mínima.
2. **Non-root**: Usuário não-root no container final.
3. **Compose**: `docker-compose.yml` com PostgreSQL + Redis (opcional).
4. **Healthcheck**: Endpoint `/healthz` com readiness probe.

## CI/CD

1. **Lint**: `golangci-lint run` (Go) / `flutter analyze` (Flutter).
2. **Testes**: `go test ./...` / `flutter test`.
3. **Coverage**: Mínimo 70%.
4. **PR**: Bloqueia merge se testes falharem.

## Protobuf

1. **Source of Truth**: `.proto` files em `api/proto/` são a única fonte da verdade dos contratos.
2. **Versionamento**: Pacotes versionados (ex: `package ecowallet.v1`).
3. **Content-Type**: `application/x-protobuf` para payloads binários.
4. **Geração**: Makefile com targets `protoc-gen-go`, `protoc-gen-dart`.

## Documentação

1. **README**: Explica produto, stack, setup e arquitetura em <2 min.
2. **docs/architecture.md**: Diagrama C4 Context + Container.
3. **docs/case-study.md**: Problema, solução, decisões e trade-offs.
4. **docs/api.md**: Endpoints, autenticação, Protobuf e exemplos.
5. **Design docs**: Decisões arquiteturais registradas como ADRs em `docs/adr/`.

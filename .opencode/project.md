# EcoWallet — Projeto

## Descrição

EcoWallet é uma plataforma de controle financeiro pessoal. O MVP atual é um aplicativo Flutter offline-first com SQLite, BLoC e Clean Architecture. O plano de evolução visa transformá-lo em uma plataforma financeira full-stack, cloud-native e orientada a eventos.

## Objetivo Principal

Servir como projeto de portfólio demonstrando habilidades em:
- Mobile Engineering (Flutter)
- Backend Engineering (Go)
- Full-Stack Integration (Flutter + Go)
- Cloud/Platform Engineering (Docker, AWS, CI/CD)

## Problema

Usuários precisam registrar gastos mesmo offline e sincronizar dados com segurança quando voltarem à internet.

## Solução Alvo

App Flutter offline-first integrado a backend Go com autenticação JWT, PostgreSQL, eventos assíncronos e deploy cloud-native.

## Arquitetura

Feature-First Clean Architecture no Flutter, Clean Architecture no Go, com comunicação via REST + Protobuf binário entre mobile e backend.

## Repositórios

| Repositório | Descrição | Status |
|---|---|---|
| EcoWallet-Mobile | App Flutter | ✅ Existente |
| ecowallet-backend | API Go | 📝 Planejado |
| ecowallet-notification | Serviço de notificações Node/TS | 📝 Planejado (Plus) |
| ecowallet-infra | Terraform/K8s | 📝 Planejado (Plus) |

## Público-alvo

Recrutadores e entrevistadores técnicos para vagas Mobile, Backend, Full-Stack e Platform Engineering.

## Fases do Projeto

- **Fase 0**: Portfolio Foundation (documentação, contratos, diagramas)
- **Fase 1**: Backend Go + PostgreSQL + Protobuf + Docker ← **ATUAL**
- **Fase 2**: Flutter como Cliente API Offline-First
- **Fase 3**: Mensageria e Eventos Financeiros
- **Fase 4**: Cloud, CI/CD e Observabilidade
- **Fase 5**: Microserviço Node.js/TypeScript (Plus)

# API - Sistema de Tarefas

API REST desenvolvida em C# (.NET 8) para gerenciamento de tarefas.

## 🚀 Como executar

### Com Docker (da raiz do projeto)

```bash
# Na raiz do repositório
docker compose up --build
```

A API estará disponível em: `http://localhost:8080`

### Sem Docker

```bash
cd api-csharp
dotnet restore
dotnet run
```

> **Nota:** Configure a connection string do MySQL no `appsettings.json`

## 📋 Funcionalidades

- Listar todas as tarefas
- Criar nova tarefa
- Editar tarefa existente
- Excluir tarefa
- Filtrar por status (open/done)
- Ordenar por título ou data de vencimento

## 🛠️ Tecnologias

- .NET 8
- Entity Framework Core
- MySQL
- Swagger (documentação da API)

## 📍 Endpoints

- `GET /api/Tasks` - Listar tarefas
- `GET /api/Tasks/{id}` - Obter tarefa específica
- `POST /api/Tasks` - Criar tarefa
- `PUT /api/Tasks/{id}` - Atualizar tarefa
- `DELETE /api/Tasks/{id}` - Excluir tarefa

## 📖 Documentação

Acesse o Swagger em: `http://localhost:8080/swagger`

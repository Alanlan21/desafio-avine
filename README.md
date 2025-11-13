# Sistema de Gerenciamento de Tarefas

Sistema completo de gerenciamento de tarefas com três interfaces diferentes: Web moderna (Next.js), ASP Classic e uma API REST em C#.

## 📁 Estrutura do Projeto

```
desafio-avine/
├── api-csharp/    # API REST em C# (.NET 8)
├── web/           # Interface web moderna (Next.js + TypeScript)
└── asp/           # Interface ASP Classic (VBScript)
```

## 🚀 Início Rápido

### Opção 1: Com Docker (Recomendado)

Suba a API + Web + MySQL com um único comando:

```bash
docker compose up --build
```

Acesse:

- **API:** `http://localhost:8080`
- **Web:** `http://localhost:3000`
- **Swagger:** `http://localhost:8080/swagger`

### Opção 2: Manualmente

#### 1. Iniciar a API

```bash
cd api-csharp
docker compose up --build
```

A API estará disponível em: `http://localhost:8080`

#### 2. Iniciar a Web

```bash
cd web
npm install
npm run dev
```

Acesse: `http://localhost:3000`

#### 3. ASP Classic (Opcional)

1. Configure o IIS (Windows)
2. Aponte para a pasta `asp/`
3. Acesse: `http://localhost/index.asp`

## 💡 Decisões Técnicas

### Docker

Optei por usar Docker para evitar instalar o SDK do .NET e outras dependências na máquina. Além disso, facilita para qualquer pessoa rodar o projeto com um único comando (`docker compose up`) e garante que o ambiente seja reproduzível.

### .NET 8

Escolhi a versão 8 por estabilidade. Versões mais novas estavam gerando conflito com o provider MySQL e o EF Core, então preferi manter algo previsível e compatível com o ambiente Docker.

### Estrutura da API

Usei o modelo clássico com _Controllers_, _Models_, _DTOs_ e _DbContext_. É direto, fácil de entender e cobre bem o escopo do desafio sem adicionar camadas desnecessárias.

### Frontend (Next.js + Tailwind)

Usei Next.js pela integração simples com APIs REST e Tailwind pela velocidade e consistência no layout. Acabei ficando numa versão anterior do Tailwind porque a mais nova estava conflitando com dependências do Next.

### Integração

Configurei a comunicação entre os serviços via variáveis de ambiente. O Next consome a API usando `NEXT_PUBLIC_API_URL`, e todos os containers compartilham o mesmo banco MySQL.

### ASP Clássico

Decidi não dockerizar essa parte porque o ASP depende do IIS, que só roda direito em ambiente Windows. Ele roda localmente e usa o mesmo banco do container.

## 📋 Funcionalidades

- ✅ Criar tarefas
- ✅ Listar tarefas
- ✅ Editar tarefas
- ✅ Excluir tarefas
- ✅ Marcar como concluída/reabrir
- ✅ Filtrar por status
- ✅ Ordenar por título ou data de vencimento

## 🛠️ Tecnologias

### API

- .NET 8
- Entity Framework Core
- MySQL
- Docker

### Web

- Next.js 15
- React 19
- TypeScript
- Tailwind CSS

### ASP Classic

- VBScript
- IIS

## 📖 Documentação

Cada pasta possui seu próprio README com instruções detalhadas:

- [API README](./api-csharp/README.md)
- [Web README](./web/README.md)
- [ASP README](./asp/README.md)

## 🔗 Endpoints da API

- `GET /api/Tasks` - Listar tarefas
- `GET /api/Tasks/{id}` - Obter tarefa
- `POST /api/Tasks` - Criar tarefa
- `PUT /api/Tasks/{id}` - Atualizar tarefa
- `DELETE /api/Tasks/{id}` - Excluir tarefa

Documentação completa: `http://localhost:8080/swagger`

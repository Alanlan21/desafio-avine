# Web - Sistema de Tarefas

Interface web moderna desenvolvida em Next.js com TypeScript.

## 🚀 Como executar

### Com Docker (da raiz do projeto)

```bash
# Na raiz do repositório
docker compose up --build
```

Acesse: `http://localhost:3000`

### Sem Docker

```bash
cd web
npm install
npm run dev
```

Acesse: `http://localhost:3000`

### Build para produção

```bash
npm run build
npm start
```

## 📋 Funcionalidades

- Listar tarefas com filtros e ordenação
- Criar nova tarefa
- Editar tarefa existente
- Excluir tarefa
- Marcar como concluída/reabrir
- Interface responsiva e moderna
- Atualização em tempo real

## 🛠️ Tecnologias

- Next.js 15
- React 19
- TypeScript
- Tailwind CSS

## ⚙️ Configuração

Certifique-se de que a API esteja rodando em `http://localhost:8080`

Se necessário, ajuste a URL da API em `src/lib/tasks-api.ts`

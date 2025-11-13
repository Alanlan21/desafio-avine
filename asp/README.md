# ASP Classic - Sistema de Tarefas

Interface web desenvolvida em ASP Classic (VBScript) que consome a API REST.

## 🚀 Como executar

### Requisitos

- Windows com IIS instalado
- ASP Classic habilitado no IIS
- API rodando em `http://localhost:8080`

### Configuração

1. Habilite o IIS e ASP:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-ASP -All
```

2. Crie um site no IIS apontando para a pasta `asp/`

3. Acesse: `http://localhost/index.asp`

## 📋 Funcionalidades

- Listar tarefas com filtros
- Criar nova tarefa
- Editar tarefa
- Excluir tarefa
- Alternar status (aberta/concluída)

## 📁 Arquivos

- `index.asp` - Lista de tarefas
- `create.asp` - Criar tarefa
- `edit.asp` - Editar tarefa
- `delete.asp` - Excluir tarefa
- `toggle.asp` - Alternar status
- `utils.asp` - Funções auxiliares

## 📝 Como Usar

1. Acesse `http://localhost/asp/` ou `http://localhost/asp/index.asp`
2. Use os botões para criar, editar ou excluir tarefas
3. Use os filtros para ordenar e filtrar por status

## 🔌 Integração com a API

Todas as operações fazem chamadas HTTP para a API .NET:

- **GET** `/tasks` - Lista tarefas
- **GET** `/tasks/{id}` - Obtém tarefa específica
- **POST** `/tasks` - Cria nova tarefa
- **PUT** `/tasks/{id}` - Atualiza tarefa
- **PATCH** `/tasks/{id}/toggle` - Alterna status
- **DELETE** `/tasks/{id}` - Exclui tarefa

### Formato JSON

**Criar/Atualizar Tarefa:**

```json
{
  "title": "Título da tarefa",
  "description": "Descrição detalhada",
  "dueDate": "2025-11-15T00:00:00Z",
  "status": "open"
}
```

## 🛠️ Arquitetura

### utils.asp

Contém funções auxiliares:

- `CallAPI(method, endpoint, jsonBody)` - Faz requisições HTTP
- `HTMLEncode(text)` - Previne XSS
- `FormatDate(isoDate)` - Formata datas
- `GetQueryString(param, default)` - Obtém parâmetros da URL
- `ShowMessage(type, text)` - Exibe mensagens de feedback

### Fluxo de Dados

```
[Navegador] <--> [ASP Classic] <--> [API .NET] <--> [MySQL]
```

A aplicação ASP **NÃO** acessa o banco de dados diretamente. Todas as operações passam pela API REST.

## ⚠️ Observações

- **Parse JSON**: Implementado com RegEx (simplificado). Para produção, considere usar componentes JSON nativos do IIS ou bibliotecas externas.
- **Segurança**: Implementa `HTMLEncode` para prevenir XSS. Em produção, adicione autenticação e autorização.
- **Erro Handling**: Tratamento básico com `On Error Resume Next`. Mensagens de erro são exibidas ao usuário.
- **Encoding**: UTF-8 configurado em todas as páginas.

## 🐛 Troubleshooting

### Erro "Objeto HTTP não pode ser criado"

Verifique se `MSXML2.ServerXMLHTTP.6.0` está disponível no servidor. Versões alternativas:

- `MSXML2.ServerXMLHTTP.3.0`
- `MSXML2.ServerXMLHTTP`

### API não responde

1. Verifique se a API .NET está rodando
2. Teste manualmente: `curl http://host.docker.internal:8080/tasks`
3. Verifique firewall e configurações de rede
4. Em ambientes Docker, use `host.docker.internal` no Windows/Mac ou IP do host no Linux

### Caracteres especiais não aparecem

Verifique se todas as páginas têm:

```asp
<%
Response.Charset = "UTF-8"
%>
```

E no HTML:

```html
<meta charset="UTF-8" />
```

## 📄 Licença

Este projeto é parte do Desafio Avine.

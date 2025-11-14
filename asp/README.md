# ASP Classic - Sistema de Tarefas

Interface web desenvolvida em **ASP Classic (VBScript)** que **consome diretamente a API REST em C#/.NET** através de chamadas HTTP.

## 🎯 Diferencial desta Implementação

⚠️ **IMPORTANTE**: Esta solução **NÃO se conecta diretamente ao banco de dados MySQL**.

Ao invés de criar uma nova conexão ao banco, esta implementação:

- ✅ **Reutiliza completamente a API C#/.NET** já existente
- ✅ **Faz chamadas HTTP REST** para todos os endpoints (GET, POST, PUT, DELETE)
- ✅ **Compartilha a mesma lógica de negócio** entre todas as interfaces
- ✅ **Evita duplicação de código** e regras de validação
- ✅ **Mantém arquitetura consistente** - uma única fonte de verdade (a API)
- ✅ **Demonstra integração entre tecnologias legadas e modernas**


## 🚀 Como executar

### Requisitos

- Windows com IIS instalado
- ASP Classic habilitado no IIS
- **API C# rodando em `http://localhost:8080`** (obrigatório!)

### Configuração

1. Habilite o IIS e ASP:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-ASP -All
```

2. Crie um site no IIS apontando para a pasta `asp/`

3. **Certifique-se que a API está rodando**: `http://localhost:8080/api/tasks`

4. Acesse: `http://localhost/index.asp`

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

**Todas as operações fazem chamadas HTTP diretas** para a API .NET rodando em `http://localhost:8080`:

- **GET** `/api/Tasks` - Lista tarefas (com filtros opcionais: status, orderBy, order)
- **GET** `/api/Tasks/{id}` - Obtém tarefa específica
- **POST** `/api/Tasks` - Cria nova tarefa
- **PUT** `/api/Tasks/{id}` - Atualiza tarefa
- **DELETE** `/api/Tasks/{id}` - Exclui tarefa

**Implementação técnica**: Utiliza `MSXML2.ServerXMLHTTP` para fazer requisições HTTP e parsear respostas JSON através de RegEx (função `ExtractJSON` em `utils.asp`).

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

### Fluxo de Dados

```
[Navegador] <--> [ASP Classic] <-HTTP REST--> [API .NET] <--> [MySQL]
```

⚠️ **A aplicação ASP NÃO acessa o banco de dados diretamente**. Todas as operações passam pela API REST, garantindo:
- Consistência de dados
- Validações centralizadas
- Reutilização de lógica de negócio
- Facilidade de manutenção

### utils.asp - Funções Principais

**CallAPI(method, endpoint, jsonBody)** - Executa requisições HTTP
```vbscript
Function CallAPI(method, endpoint, jsonBody)
    Set http = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
    url = API_BASE_URL & endpoint  ' http://localhost:8080/api/Tasks
    http.Open method, url, False
    http.setRequestHeader "Content-Type", "application/json"
    http.Send jsonBody
    ' Retorna Dictionary com Success e Data
End Function
```

**ExtractJSON(json, field)** - Parseia JSON com RegEx (sem bibliotecas externas)

**JSONEncode(text)** - Escapa caracteres especiais para JSON válido

**HTMLEncode(text)** - Previne XSS em outputs HTML

**FormatDate(isoDate)** - Formata datas ISO para dd/mm/yyyy

**GetQueryString(param, default)** - Obtém parâmetros da URL com fallback

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

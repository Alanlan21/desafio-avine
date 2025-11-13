# 🚀 GUIA RÁPIDO - EXECUTAR AGORA (5 MINUTOS)

## 📋 Checklist Pré-Execução

### 1. API C# está rodando?

```powershell
Test-NetConnection localhost -Port 8080
# Deve retornar TcpTestSucceeded : True
```

Se não estiver, iniciar:

```powershell
cd "e:\Workspaces VScode\Desafio Avine\api-csharp"
dotnet run
```

### 2. IIS está instalado?

```powershell
Get-Service W3SVC
# Status deve ser "Running"
```

**Se não estiver instalado (1 MINUTO):**

```powershell
# Execute como ADMINISTRADOR
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-ASP -All
```

### 3. Criar Site IIS (30 SEGUNDOS)

**Opção A - PowerShell (ADMINISTRADOR):**

```powershell
Import-Module WebAdministration
New-IISSite -Name "ASPTasks" -BindingInformation "*:80:" -PhysicalPath "E:\Workspaces VScode\Desafio Avine\asp"
```

**Opção B - Interface Gráfica:**

1. Executar: `inetmgr`
2. Sites → Add Website
3. Nome: `ASPTasks`
4. Caminho físico: `E:\Workspaces VScode\Desafio Avine\asp`
5. Porta: `80`

### 4. Testar (10 SEGUNDOS)

Abrir navegador:

```
http://localhost/test-api.asp
```

**Resultado esperado:**

- ✅ "Teste ASP - Funcionando!"
- ✅ "Objeto HTTP criado com sucesso!"
- ✅ "Requisição OK! Status: 200"

### 5. Acessar Aplicação

```
http://localhost/index.asp
```

---

## ⚡ SOLUÇÃO RÁPIDA DE PROBLEMAS

### ❌ Erro: "Página não pode ser exibida"

**Solução 1 - IIS não está rodando:**

```powershell
Start-Service W3SVC
```

**Solução 2 - ASP não habilitado:**

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASP
```

### ❌ Erro: "HTTP/1.1 Falha no Novo Aplicativo"

**Causa:** API não está rodando ou não aceita conexões

**Solução:**

```powershell
# Terminal 1 - Iniciar API
cd "e:\Workspaces VScode\Desafio Avine\api-csharp"
dotnet run

# Aguardar mensagem:
# Now listening on: http://localhost:8080
```

Verificar CORS no `Program.cs` da API:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
    });
});

// Antes de app.Run():
app.UseCors();
```

### ❌ Erro: "HTTP 403 - Proibido"

**Solução - Permissões:**

```powershell
icacls "E:\Workspaces VScode\Desafio Avine\asp" /grant IIS_IUSRS:(OI)(CI)F /T
```

### ❌ Erro ao criar/editar tarefa

**Teste direto na API:**

```powershell
# Listar tarefas
Invoke-WebRequest -Uri "http://localhost:8080/api/Tasks" -Method GET

# Criar tarefa
$body = @{
    title = "Teste"
    description = "Teste"
    dueDate = "2025-12-31T00:00:00Z"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:8080/api/Tasks" -Method POST -Body $body -ContentType "application/json"
```

Se funcionar, o problema está no ASP. Se não funcionar, o problema está na API.

---

## 🎯 COMANDO ÚNICO (Se tudo estiver instalado)

```powershell
# 1. Parar qualquer site conflitante
Stop-IISSite -Name "Default Web Site" -ErrorAction SilentlyContinue

# 2. Criar/recriar site
Remove-IISSite -Name "ASPTasks" -ErrorAction SilentlyContinue
New-IISSite -Name "ASPTasks" -BindingInformation "*:80:" -PhysicalPath "E:\Workspaces VScode\Desafio Avine\asp"

# 3. Iniciar site
Start-IISSite -Name "ASPTasks"

# 4. Abrir navegador
Start-Process "http://localhost/index.asp"
```

---

## 📊 STATUS DA APLICAÇÃO

### Arquivos corrigidos:

- ✅ `utils.asp` - Melhorado tratamento HTTP e encoding
- ✅ `create.asp` - Reescrito do zero
- ✅ `edit.asp` - Reescrito do zero
- ✅ `delete.asp` - Reescrito do zero
- ✅ `toggle.asp` - Reescrito do zero
- ✅ `test-api.asp` - Criado para diagnóstico
- ✅ `index.asp` - Já estava funcional

### Melhorias implementadas:

- ✅ Fallback para múltiplas versões do XMLHTTP
- ✅ Encoding correto de JSON (escapes de caracteres)
- ✅ Melhor tratamento de erros
- ✅ Parse JSON simplificado e robusto
- ✅ Charset UTF-8 configurado
- ✅ Código limpo e legível

---

## ⏱️ TEMPO TOTAL: 3-5 MINUTOS

Boa sorte com o teste técnico! 🚀

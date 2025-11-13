<%@ Language=VBScript %>
<%
Option Explicit
Response.Charset = "UTF-8"
%>
<!-- #include file="utils.asp" -->
<%
' ============================================================================
' INDEX.ASP - Lista todas as tarefas com filtros
' ============================================================================

Dim apiResult, tasks, statusFilter, orderBy, orderDir, queryString

' Obter parâmetros de filtro
statusFilter = GetQueryString("status", "all")
orderBy = GetQueryString("orderBy", "due_date")
orderDir = GetQueryString("order", "asc")

' Montar query string para a API
queryString = "?orderBy=" & orderBy & "&order=" & orderDir
If statusFilter <> "all" Then
    queryString = queryString & "&status=" & statusFilter
End If

' Chamar API para obter tarefas
Set apiResult = CallAPI("GET", queryString, "")

' Verificar se houve erro
Dim hasError
hasError = Not apiResult("Success")

' Mensagens de feedback
Dim msgType, msgText
msgType = Request.QueryString("msg")
If msgType = "created" Then
    Call ShowMessage("success", "Tarefa criada com sucesso!")
ElseIf msgType = "updated" Then
    Call ShowMessage("success", "Tarefa atualizada com sucesso!")
ElseIf msgType = "deleted" Then
    Call ShowMessage("success", "Tarefa excluída com sucesso!")
ElseIf msgType = "toggled" Then
    Call ShowMessage("success", "Status da tarefa alterado!")
End If
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Tarefas - ASP Clássico</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }
        h1 { color: #333; margin-bottom: 20px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .btn { padding: 10px 20px; background: #4CAF50; color: white; text-decoration: none; border-radius: 4px; border: none; cursor: pointer; display: inline-block; }
        .btn:hover { background: #45a049; }
        .btn-danger { background: #f44336; }
        .btn-danger:hover { background: #da190b; }
        .btn-small { padding: 5px 10px; font-size: 12px; margin: 0 2px; }
        .filters { background: white; padding: 15px; border-radius: 4px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .filter-group { display: inline-block; margin-right: 20px; }
        .filter-group label { margin-right: 5px; font-weight: bold; }
        .filter-group select { padding: 5px; border-radius: 4px; border: 1px solid #ddd; }
        table { width: 100%; background: white; border-collapse: collapse; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #4CAF50; color: white; font-weight: bold; }
        tr:hover { background: #f5f5f5; }
        .status-open { color: #ff9800; font-weight: bold; }
        .status-done { color: #4CAF50; font-weight: bold; }
        .actions { white-space: nowrap; }
        .error { background: #f44336; color: white; padding: 15px; border-radius: 4px; margin-bottom: 20px; }
        .message { padding: 15px; border-radius: 4px; margin-bottom: 20px; display: flex; align-items: center; }
        .msg-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .msg-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .msg-icon { font-size: 20px; margin-right: 10px; }
        .empty { text-align: center; padding: 40px; color: #999; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📋 Sistema de Tarefas</h1>
            <a href="create.asp" class="btn">+ Nova Tarefa</a>
        </div>

        <% If hasError Then %>
            <div class="error">
                <strong>Erro ao carregar tarefas:</strong><br>
                <%= HTMLEncode(apiResult("Data")) %>
            </div>
        <% Else %>
            <div class="filters">
                <form method="get" action="index.asp">
                    <div class="filter-group">
                        <label>Status:</label>
                        <select name="status" onchange="this.form.submit()">
                            <option value="all" <% If statusFilter = "all" Then Response.Write "selected" %>>Todas</option>
                            <option value="open" <% If statusFilter = "open" Then Response.Write "selected" %>>Abertas</option>
                            <option value="done" <% If statusFilter = "done" Then Response.Write "selected" %>>Concluídas</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label>Ordenar por:</label>
                        <select name="orderBy" onchange="this.form.submit()">
                            <option value="due_date" <% If orderBy = "due_date" Then Response.Write "selected" %>>Vencimento</option>
                            <option value="created_at" <% If orderBy = "created_at" Then Response.Write "selected" %>>Criação</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label>Ordem:</label>
                        <select name="order" onchange="this.form.submit()">
                            <option value="asc" <% If orderDir = "asc" Then Response.Write "selected" %>>Crescente</option>
                            <option value="desc" <% If orderDir = "desc" Then Response.Write "selected" %>>Decrescente</option>
                        </select>
                    </div>
                    
                    <input type="hidden" name="status" value="<%= statusFilter %>">
                </form>
            </div>

            <%
            ' Parse do JSON (implementação simplificada usando RegEx)
            Dim jsonData, taskCount
            jsonData = apiResult("Data")
            
            ' Verificar se há tarefas
            If jsonData = "[]" Or jsonData = "" Then
                taskCount = 0
            Else
                ' Contar tarefas (conta quantas vezes aparece "id":)
                Dim regex
                Set regex = New RegExp
                regex.Pattern = """id""\s*:\s*\d+"
                regex.Global = True
                taskCount = regex.Execute(jsonData).Count
                Set regex = Nothing
            End If
            
            If taskCount = 0 Then
            %>
                <div class="empty">
                    Nenhuma tarefa encontrada.<br>
                    <a href="create.asp">Criar primeira tarefa</a>
                </div>
            <% Else %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Título</th>
                            <th>Descrição</th>
                            <th>Vencimento</th>
                            <th>Status</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    ' Parse manual do JSON (simplificado)
                    ' Em produção, use uma biblioteca JSON apropriada
                    Dim pattern, matches, i, task
                    Set regex = New RegExp
                    
                    ' Pattern para extrair cada tarefa
                    regex.Pattern = "\{[^\}]+\}"
                    regex.Global = True
                    Set matches = regex.Execute(jsonData)
                    
                    For i = 0 To matches.Count - 1
                        Dim taskJson, taskId, taskTitle, taskDescription, taskDueDate, taskStatus
                        taskJson = matches(i).Value
                        
                        ' Extrair campos usando regex
                        taskId = ExtractJSONField(taskJson, "id")
                        taskTitle = ExtractJSONField(taskJson, "title")
                        taskDescription = ExtractJSONField(taskJson, "description")
                        taskDueDate = ExtractJSONField(taskJson, "dueDate")
                        taskStatus = ExtractJSONField(taskJson, "status")
                        
                        Dim statusText, statusClass
                        If taskStatus = "done" Then
                            statusText = "Concluída"
                            statusClass = "status-done"
                        Else
                            statusText = "Aberta"
                            statusClass = "status-open"
                        End If
                    %>
                        <tr>
                            <td><%= taskId %></td>
                            <td><%= HTMLEncode(taskTitle) %></td>
                            <td><%= HTMLEncode(taskDescription) %></td>
                            <td><%= FormatDate(taskDueDate) %></td>
                            <td class="<%= statusClass %>"><%= statusText %></td>
                            <td class="actions">
                                <a href="toggle.asp?id=<%= taskId %>&returnUrl=index.asp" class="btn btn-small">
                                    <% If taskStatus = "done" Then %>Reabrir<% Else %>Concluir<% End If %>
                                </a>
                                <a href="edit.asp?id=<%= taskId %>" class="btn btn-small">Editar</a>
                                <a href="delete.asp?id=<%= taskId %>" class="btn btn-small btn-danger" onclick="return confirm('Deseja realmente excluir esta tarefa?')">Excluir</a>
                            </td>
                        </tr>
                    <%
                    Next
                    Set regex = Nothing
                    %>
                    </tbody>
                </table>
            <% End If %>
        <% End If %>
    </div>
</body>
</html>

<%
' ----------------------------------------------------------------------------
' Função auxiliar para extrair campo do JSON
' ----------------------------------------------------------------------------
Function ExtractJSONField(jsonString, fieldName)
    Dim regex, matches
    Set regex = New RegExp
    regex.Pattern = """" & fieldName & """\s*:\s*""?([^"",\}]+)""?"
    regex.IgnoreCase = True
    Set matches = regex.Execute(jsonString)
    
    If matches.Count > 0 Then
        ExtractJSONField = matches(0).SubMatches(0)
    Else
        ExtractJSONField = ""
    End If
    Set regex = Nothing
End Function
%>

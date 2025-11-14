<%@ Language=VBScript CODEPAGE=65001 %>
<%
Option Explicit
Response.CodePage = 65001
Response.Charset = "UTF-8"
%>
<!-- #include file="utils.asp" -->
<%
Dim isPost, apiResult, errorMsg
isPost = (Request.ServerVariables("REQUEST_METHOD") = "POST")

If isPost Then
    Dim title, description, dueDate, jsonBody
    
    title = Trim(Request.Form("title"))
    description = Trim(Request.Form("description"))
    dueDate = Request.Form("dueDate")
    
    If title = "" Then
        errorMsg = "O título é obrigatório"
    ElseIf dueDate = "" Then
        errorMsg = "A data de vencimento é obrigatória"
    Else
        jsonBody = "{" & _
                   """title"": """ & JSONEncode(title) & """," & _
                   """description"": """ & JSONEncode(description) & """," & _
                   """dueDate"": """ & dueDate & "T00:00:00""" & _
                   "}"
        
        Set apiResult = CallAPI("POST", "", jsonBody)
        
        If apiResult("Success") Then
            Response.Redirect "index.asp?msg=" & Server.URLEncode("Tarefa criada com sucesso!")
            Response.End
        Else
            errorMsg = "Erro ao criar tarefa: " & apiResult("error")
        End If
    End If
End If
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nova Tarefa - Sistema de Tarefas</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #333; margin-bottom: 24px; font-size: 24px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; color: #555; font-weight: 500; }
        input[type="text"], input[type="date"], textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; font-family: inherit; }
        textarea { min-height: 100px; resize: vertical; }
        .button-group { display: flex; gap: 10px; margin-top: 24px; }
        button, .btn { padding: 10px 20px; border: none; border-radius: 4px; font-size: 14px; cursor: pointer; text-decoration: none; display: inline-block; text-align: center; }
        button[type="submit"] { background: #4CAF50; color: white; flex: 1; }
        button[type="submit"]:hover { background: #45a049; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }
        .error { background: #f8d7da; color: #721c24; padding: 12px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #f5c6cb; }
        .back-link { color: #007bff; text-decoration: none; margin-bottom: 20px; display: inline-block; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <a href="index.asp" class="back-link">← Voltar para lista</a>
        
        <h1>✏️ Nova Tarefa</h1>
        
        <% If errorMsg <> "" Then %>
            <div class="error"><%= errorMsg %></div>
        <% End If %>
        
        <form method="POST" action="create.asp">
            <div class="form-group">
                <label for="title">Título *</label>
                <input type="text" id="title" name="title" required 
                       value="<%= Server.HTMLEncode(Request.Form("title")) %>">
            </div>
            
            <div class="form-group">
                <label for="description">Descrição</label>
                <textarea id="description" name="description"><%= Server.HTMLEncode(Request.Form("description")) %></textarea>
            </div>
            
            <div class="form-group">
                <label for="dueDate">Data de Vencimento *</label>
                <input type="date" id="dueDate" name="dueDate" required
                       value="<%= Request.Form("dueDate") %>">
            </div>
            
            <div class="button-group">
                <button type="submit">Criar Tarefa</button>
                <a href="index.asp" class="btn btn-secondary">Cancelar</a>
            </div>
        </form>
    </div>
</body>
</html>

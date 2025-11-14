<%@ Language=VBScript CODEPAGE=65001 %>
<%
Option Explicit
Response.CodePage = 65001
Response.Charset = "UTF-8"
%>
<!-- #include file="utils.asp" -->
<%
Dim taskId, isPost, apiResult, errorMsg, task
taskId = Request.QueryString("id")

If taskId = "" Or Not IsNumeric(taskId) Then
    Response.Redirect "index.asp"
    Response.End
End If

isPost = (Request.ServerVariables("REQUEST_METHOD") = "POST")

If isPost Then
    Dim title, description, dueDate, status, jsonBody
    
    title = Trim(Request.Form("title"))
    description = Trim(Request.Form("description"))
    dueDate = Request.Form("dueDate")
    status = Request.Form("status")
    
    If title = "" Then
        errorMsg = "O título é obrigatório"
    ElseIf dueDate = "" Then
        errorMsg = "A data de vencimento é obrigatória"
    Else
        jsonBody = "{" & _
            """title"":""" & JSONEncode(title) & """," & _
            """description"":""" & JSONEncode(description) & """," & _
            """dueDate"":""" & dueDate & "T00:00:00Z""," & _
            """status"":""" & status & """" & _
            "}"
        
        Set apiResult = CallAPI("PUT", "/" & taskId, jsonBody)
        
        If apiResult("Success") Then
            Response.Redirect "index.asp?msg=updated"
            Response.End
        Else
            errorMsg = "Erro: " & apiResult("Data")
        End If
    End If
Else
    Set apiResult = CallAPI("GET", "/" & taskId, "")
    
    If Not apiResult("Success") Then
        Response.Redirect "index.asp"
        Response.End
    End If
    
    Dim jsonData
    jsonData = apiResult("Data")
    
    Set task = Server.CreateObject("Scripting.Dictionary")
    task.Add "title", ExtractJSON(jsonData, "title")
    task.Add "description", ExtractJSON(jsonData, "description")
    task.Add "dueDate", Left(ExtractJSON(jsonData, "dueDate"), 10)
    task.Add "status", ExtractJSON(jsonData, "status")
End If

Function ExtractJSON(json, field)
    Dim p, s, e
    p = InStr(json, """" & field & """:""")
    If p = 0 Then ExtractJSON = "": Exit Function
    s = p + Len(field) + 4
    e = InStr(s, json, """")
    ExtractJSON = Mid(json, s, e - s)
End Function
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Editar Tarefa</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        h1 { color: #333; margin-bottom: 20px; }
        .form-card { background: white; padding: 30px; border-radius: 4px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
        .form-group textarea { min-height: 100px; }
        .btn { padding: 10px 20px; border-radius: 4px; border: none; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background: #4CAF50; color: white; }
        .btn-secondary { background: #999; color: white; }
        .error { background: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Editar Tarefa</h1>
        <% If errorMsg <> "" Then %>
            <div class="error"><%= HTMLEncode(errorMsg) %></div>
        <% End If %>
        <div class="form-card">
            <form method="post">
                <div class="form-group">
                    <label>Título *</label>
                    <input type="text" name="title" required value="<%= HTMLEncode(task("title")) %>">
                </div>
                <div class="form-group">
                    <label>Descrição</label>
                    <textarea name="description"><%= HTMLEncode(task("description")) %></textarea>
                </div>
                <div class="form-group">
                    <label>Data *</label>
                    <input type="date" name="dueDate" required value="<%= task("dueDate") %>">
                </div>
                <div class="form-group">
                    <label>Status *</label>
                    <select name="status" required>
                        <option value="open" <% If task("status") = "open" Then Response.Write "selected" %>>Em Aberto</option>
                        <option value="done" <% If task("status") = "done" Then Response.Write "selected" %>>Concluída</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Salvar</button>
                <a href="index.asp" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>
    </div>
</body>
</html>

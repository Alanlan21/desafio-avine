<%@ Language=VBScript %> <% Option Explicit Response.Charset = "UTF-8"
Response.CodePage = 65001 %>
<!-- #include file="utils.asp" -->
<% Dim isPost, apiResult, errorMsg isPost =
(Request.ServerVariables("REQUEST_METHOD") = "POST") If isPost Then Dim title,
description, dueDate, jsonBody title = Trim(Request.Form("title")) description =
Trim(Request.Form("description")) dueDate = Request.Form("dueDate") If title =
"" Then errorMsg = "O título é obrigatório" ElseIf dueDate = "" Then errorMsg =
"A data de vencimento é obrigatória" Else jsonBody = "{" & _ """title"":""" &
JSONEncode(title) & """," & _ """description"":""" & JSONEncode(description) &
"""," & _ """dueDate"":""" & dueDate & "T00:00:00Z""" & _ "}" Set apiResult =
CallAPI("POST", "", jsonBody) If apiResult("Success") Then Response.Redirect
"index.asp?msg=created" Response.End Else errorMsg = "Erro ao criar tarefa: " &
apiResult("Data") End If End If End If %>
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <title>Nova Tarefa</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      body {
        font-family: Arial, sans-serif;
        background: #f5f5f5;
        padding: 20px;
      }
      .container {
        max-width: 600px;
        margin: 0 auto;
      }
      h1 {
        color: #333;
        margin-bottom: 20px;
      }
      .form-card {
        background: white;
        padding: 30px;
        border-radius: 4px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }
      .form-group {
        margin-bottom: 20px;
      }
      .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
      }
      .form-group input,
      .form-group textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
      }
      .form-group textarea {
        min-height: 100px;
      }
      .btn {
        padding: 10px 20px;
        border-radius: 4px;
        border: none;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
      }
      .btn-primary {
        background: #4caf50;
        color: white;
      }
      .btn-secondary {
        background: #999;
        color: white;
      }
      .error {
        background: #f8d7da;
        color: #721c24;
        padding: 15px;
        border-radius: 4px;
        margin-bottom: 20px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>Nova Tarefa</h1>
      <% If errorMsg <> "" Then %>
      <div class="error"><%= HTMLEncode(errorMsg) %></div>
      <% End If %>
      <div class="form-card">
        <form method="post">
          <div class="form-group">
            <label>Título *</label>
            <input type="text" name="title" required value="<%=
            HTMLEncode(Request.Form("title")) %>">
          </div>
          <div class="form-group">
            <label>Descrição</label>
            <textarea name="description">
<%= HTMLEncode(Request.Form("description")) %></textarea
            >
          </div>
          <div class="form-group">
            <label>Data de Vencimento *</label>
            <input type="date" name="dueDate" required value="<%=
            Request.Form("dueDate") %>">
          </div>
          <button type="submit" class="btn btn-primary">Salvar</button>
          <a href="index.asp" class="btn btn-secondary">Cancelar</a>
        </form>
      </div>
    </div>
  </body>
</html>

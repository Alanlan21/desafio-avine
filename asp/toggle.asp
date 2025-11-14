<%@ Language=VBScript CODEPAGE=65001 %>
<%
Option Explicit
Response.CodePage = 65001
Response.Charset = "UTF-8"
%>
<!-- #include file="utils.asp" -->
<%
Dim taskId, apiResult, jsonData, title, description, dueDate, status, newStatus, jsonBody
taskId = Request.QueryString("id")

If taskId = "" Or Not IsNumeric(taskId) Then
    Response.Redirect "index.asp"
    Response.End
End If

' Buscar tarefa atual
Set apiResult = CallAPI("GET", "/" & taskId, "")

If Not apiResult("Success") Then
    Response.Redirect "index.asp?error=" & Server.URLEncode("Erro ao buscar tarefa")
    Response.End
End If

' Extrair dados do JSON
jsonData = apiResult("Data")
title = ExtractJSON(jsonData, "title")
description = ExtractJSON(jsonData, "description")
dueDate = ExtractJSON(jsonData, "dueDate")
status = ExtractJSON(jsonData, "status")

' Se dueDate for null, não incluir no JSON
Dim dueDatePart
If dueDate = "" Or LCase(dueDate) = "null" Then
    dueDatePart = """dueDate"": null"
Else
    dueDatePart = """dueDate"": """ & dueDate & """"
End If

' Inverter o status
If LCase(status) = "done" Or LCase(status) = "concluída" Then
    newStatus = "open"
Else
    newStatus = "done"
End If

' Atualizar via API
jsonBody = "{" & _
           """title"": """ & JSONEncode(title) & """," & _
           """description"": """ & JSONEncode(description) & """," & _
           dueDatePart & "," & _
           """status"": """ & newStatus & """" & _
           "}"

Set apiResult = CallAPI("PUT", "/" & taskId, jsonBody)

If apiResult("Success") Then
    Response.Redirect "index.asp?msg=toggled"
Else
    Response.Redirect "index.asp?error=" & Server.URLEncode("Erro ao atualizar status")
End If
%>

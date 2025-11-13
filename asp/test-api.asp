<%@ Language=VBScript %>
<%
Option Explicit
Response.Charset = "UTF-8"
Response.CodePage = 65001
Response.Write "<!DOCTYPE html>" & vbCrLf
Response.Write "<html><head><meta charset='UTF-8'><title>Teste</title></head><body>" & vbCrLf
Response.Write "<h1>Teste ASP - Funcionando!</h1>" & vbCrLf
Response.Write "<p>Data/Hora: " & Now() & "</p>" & vbCrLf

Dim http, url, result
url = "http://localhost:8080/api/Tasks"

On Error Resume Next
Set http = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
If Err.Number <> 0 Then
    Response.Write "<p style='color:red'>Erro ao criar MSXML2.ServerXMLHTTP.6.0: " & Err.Description & "</p>" & vbCrLf
    Set http = Server.CreateObject("MSXML2.ServerXMLHTTP.3.0")
    If Err.Number <> 0 Then
        Response.Write "<p style='color:red'>Erro ao criar MSXML2.ServerXMLHTTP.3.0: " & Err.Description & "</p>" & vbCrLf
        Set http = Server.CreateObject("Microsoft.XMLHTTP")
        If Err.Number <> 0 Then
            Response.Write "<p style='color:red'>Erro ao criar Microsoft.XMLHTTP: " & Err.Description & "</p>" & vbCrLf
        End If
    End If
End If

If Not http Is Nothing Then
    Response.Write "<p style='color:green'>Objeto HTTP criado com sucesso!</p>" & vbCrLf
    
    http.Open "GET", url, False
    http.setRequestHeader "Content-Type", "application/json"
    http.Send
    
    If Err.Number <> 0 Then
        Response.Write "<p style='color:red'>Erro ao fazer requisição: " & Err.Description & "</p>" & vbCrLf
    Else
        Response.Write "<p style='color:green'>Requisição OK! Status: " & http.Status & "</p>" & vbCrLf
        Response.Write "<p>Resposta: <pre>" & Server.HTMLEncode(Left(http.ResponseText, 500)) & "</pre></p>" & vbCrLf
    End If
    
    Set http = Nothing
End If

On Error GoTo 0

Response.Write "</body></html>"
%>

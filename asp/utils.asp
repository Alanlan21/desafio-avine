<%
Const API_BASE_URL = "http://localhost:8080/api/Tasks"

' ---------------------------------------------
' Função principal para chamar API .NET
' ---------------------------------------------
Function CallAPI(method, endpoint, jsonBody)
    Dim result, http, url

    Set result = Server.CreateObject("Scripting.Dictionary")
    result.Add "Success", False
    result.Add "Data", ""

    On Error Resume Next

    Set http = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
    If Err.Number <> 0 Then
        Set http = Server.CreateObject("MSXML2.ServerXMLHTTP.3.0")
    End If
    If Err.Number <> 0 Then
        Set http = Server.CreateObject("Microsoft.XMLHTTP")
    End If

    If Err.Number <> 0 Then
        result("Data") = "Erro ao criar objeto HTTP: " & Err.Description
        Set CallAPI = result
        Exit Function
    End If

    url = API_BASE_URL & endpoint

    http.Open method, url, False
    http.setRequestHeader "Content-Type", "application/json; charset=utf-8"
    http.setRequestHeader "Accept", "application/json"

    If method = "POST" Or method = "PUT" Then
        http.Send jsonBody
    Else
        http.Send
    End If

    If Err.Number <> 0 Then
        result("Data") = "Erro na requisição: " & Err.Description
        Set CallAPI = result
        Exit Function
    End If

    If http.Status >= 200 And http.Status < 300 Then
        result("Success") = True
        result("Data") = http.ResponseText
    Else
        result("Data") = "HTTP " & http.Status & ": " & http.StatusText
    End If

    Set http = Nothing
    On Error GoTo 0

    Set CallAPI = result
End Function


' ---------------------------------------------
' HTML Encode básico
' ---------------------------------------------
Function HTMLEncode(text)
    If IsNull(text) Or text = "" Then
        HTMLEncode = ""
        Exit Function
    End If

    Dim result
    result = CStr(text)
    result = Replace(result, "&", "&amp;")
    result = Replace(result, "<", "&lt;")
    result = Replace(result, ">", "&gt;")
    result = Replace(result, """", "&quot;")
    result = Replace(result, "'", "&#39;")

    HTMLEncode = result
End Function


' ---------------------------------------------
' JSON Encode básico
' ---------------------------------------------
Function JSONEncode(text)
    If IsNull(text) Or text = "" Then
        JSONEncode = ""
        Exit Function
    End If

    Dim result
    result = CStr(text)
    result = Replace(result, "\", "\\")
    result = Replace(result, """", "\""")
    result = Replace(result, vbCr, "\r")
    result = Replace(result, vbLf, "\n")
    result = Replace(result, vbTab, "\t")

    JSONEncode = result
End Function


' ---------------------------------------------
' Formata data ISO → dd/mm/yyyy
' ---------------------------------------------
Function FormatDate(isoDate)
    If IsNull(isoDate) Or isoDate = "" Then
        FormatDate = "-"
        Exit Function
    End If

    On Error Resume Next

    Dim dateValue
    If InStr(isoDate, "T") > 0 Then
        dateValue = Left(isoDate, InStr(isoDate, "T") - 1)
    Else
        dateValue = isoDate
    End If

    Dim parts, formattedDate
    parts = Split(dateValue, "-")

    If UBound(parts) = 2 Then
        formattedDate = parts(2) & "/" & parts(1) & "/" & parts(0)
        FormatDate = formattedDate
    Else
        FormatDate = dateValue
    End If

    On Error GoTo 0
End Function


' ---------------------------------------------
' Leitura segura de QueryString
' ---------------------------------------------
Function GetQueryString(paramName, defaultValue)
    Dim value
    value = Request.QueryString(paramName)

    If IsNull(value) Or value = "" Then
        GetQueryString = defaultValue
    Else
        GetQueryString = value
    End If
End Function


' ---------------------------------------------
' Extrai valor de um campo do JSON
' ---------------------------------------------
Function ExtractJSON(json, field)
    Dim p, s, e
    p = InStr(json, """" & field & """:""")
    If p = 0 Then 
        ' Tentar formato com número (sem aspas no valor)
        p = InStr(json, """" & field & """:")
        If p = 0 Then
            ExtractJSON = ""
            Exit Function
        End If
        s = p + Len(field) + 3
        e = InStr(s, json, ",")
        If e = 0 Then e = InStr(s, json, "}")
        If e = 0 Then
            ExtractJSON = ""
        Else
            ExtractJSON = Trim(Mid(json, s, e - s))
        End If
    Else
        s = p + Len(field) + 4
        e = InStr(s, json, """")
        If e = 0 Then
            ExtractJSON = ""
        Else
            ExtractJSON = Mid(json, s, e - s)
        End If
    End If
End Function

' ---------------------------------------------
' Exibe mensagem formatada (HTML incluído)
' ---------------------------------------------
Sub ShowMessage(msgType, msgText)
    Dim cssClass, icon

    If msgType = "success" Then
        cssClass = "msg-success"
        icon = "✓"
    Else
        cssClass = "msg-error"
        icon = "✗"
    End If
%>
    <div class="message <%= cssClass %>">
        <span class="msg-icon"><%= icon %></span>
        <%= HTMLEncode(msgText) %>
    </div>
<%
End Sub
%>

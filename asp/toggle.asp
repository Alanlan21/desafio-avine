<%@ Language=VBScript %> <% Option Explicit Response.Charset = "UTF-8"
Response.CodePage = 65001 %>
<!-- #include file="utils.asp" -->
<% Dim taskId, apiResult, jsonData, title, description, dueDate, status,
newStatus, jsonBody taskId = Request.QueryString("id") If taskId = "" Or Not
IsNumeric(taskId) Then Response.Redirect "index.asp" Response.End End If Set
apiResult = CallAPI("GET", "/" & taskId, "") If Not apiResult("Success") Then
Response.Redirect "index.asp?msg=error" Response.End End If jsonData =
apiResult("Data") title = ExtractJSON(jsonData, "title") description =
ExtractJSON(jsonData, "description") dueDate = ExtractJSON(jsonData, "dueDate")
status = ExtractJSON(jsonData, "status") If status = "open" Then newStatus =
"done" Else newStatus = "open" End If jsonBody = "{" & _ """title"":""" &
JSONEncode(title) & """," & _ """description"":""" & JSONEncode(description) &
"""," & _ """dueDate"":""" & dueDate & """," & _ """status"":""" & newStatus &
"""" & _ "}" Set apiResult = CallAPI("PUT", "/" & taskId, jsonBody) If
apiResult("Success") Then Response.Redirect "index.asp?msg=toggled" Else
Response.Redirect "index.asp?msg=error" End If Response.End Function
ExtractJSON(json, field) Dim p, s, e p = InStr(json, """" & field & """:""") If
p = 0 Then ExtractJSON = "": Exit Function s = p + Len(field) + 4 e = InStr(s,
json, """") ExtractJSON = Mid(json, s, e - s) End Function %>

<%@ Language=VBScript %> <% Option Explicit Response.Charset = "UTF-8"
Response.CodePage = 65001 %>
<!-- #include file="utils.asp" -->
<% Dim taskId, apiResult taskId = Request.QueryString("id") If taskId = "" Or
Not IsNumeric(taskId) Then Response.Redirect "index.asp" Response.End End If Set
apiResult = CallAPI("DELETE", "/" & taskId, "") If apiResult("Success") Then
Response.Redirect "index.asp?msg=deleted" Else Response.Redirect
"index.asp?msg=error" End If Response.End %>

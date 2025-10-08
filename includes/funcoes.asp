<%
Response.ContentType = "application/json"

Response.Charset = "utf-8"

Response.AddHeader "Access-Control-Allow-Origin", "*"
Response.AddHeader "Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS"
Response.AddHeader "Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With, Accept, Origin"
Response.AddHeader "Access-Control-Allow-Credentials", "true"
Response.AddHeader "Access-Control-Max-Age", "86400"

If UCase(Request.ServerVariables("REQUEST_METHOD")) = "OPTIONS" Then
    Response.Status = "204 No Content"
    Response.End
End If


Sub SendResponse(sucesso, mensagem, statusCode)
    Dim sucessoJSON
    If sucesso = True Then
        sucessoJSON = "true"
    Else
        sucessoJSON = "false"
    End If
    Response.Status = statusCode
    Response.Write "{""sucesso"":" & sucessoJSON & ",""mensagem"":""" & mensagem & """}"
    Response.End
End Sub

Function GetJsonValue(json, key)
    Dim pattern, regex, matches
    pattern = """" & key & """\s*:\s*""([^""]*)"""
    Set regex = New RegExp
    regex.Pattern = pattern
    regex.IgnoreCase = True
    regex.Global = False
    Set matches = regex.Execute(json)
    If matches.Count > 0 Then
        GetJsonValue = matches(0).SubMatches(0)
    Else
        GetJsonValue = ""
    End If
End Function

Function GetJsonInt(json, key)
    Dim pattern, regex, matches
    pattern = """" & key & """\s*:\s*([0-9]+)"
    Set regex = New RegExp
    regex.Pattern = pattern
    regex.IgnoreCase = True
    regex.Global = False
    Set matches = regex.Execute(json)
    If matches.Count > 0 Then
        GetJsonInt = CLng(matches(0).SubMatches(0)) 
    Else
        GetJsonInt = Null
    End If
End Function

Function GetJsonDecimal(json, key)
    Dim pattern, regex, matches, value

    pattern = """" & key & """\s*:\s*(-?\d+(?:\.\d+)?)"

    Set regex = New RegExp
    regex.Pattern = pattern
    regex.IgnoreCase = True
    regex.Global = False

    Set matches = regex.Execute(json)
    If matches.Count > 0 Then
        value = matches(0).SubMatches(0)
        If IsNumeric(value) Then
            value = Replace(value, ".", ",")
            GetJsonDecimal = CDbl(value)
        Else
            GetJsonDecimal = Null
        End If
    Else
        GetJsonDecimal = Null
    End If
End Function

Function GetQueryParam(paramName, defaultValue)
    Dim value
    value = Request.QueryString(paramName)
    If value = "" Or IsNull(value) Then
        If defaultValue <> "" Then
            GetQueryParam = defaultValue
        Else
            GetQueryParam = ""
        End If
    Else
        GetQueryParam = value
    End If
End Function

Function RecordSetToJson(rs, rootName)
    Dim json, primeiro, campo, valor
    
    If rs.EOF Then
        RecordSetToJson = "{" & rootName & ":[]}"
        Exit Function
    End If
    
    json = "{""" & rootName & """:["
    primeiro = True
    
    Do While Not rs.EOF
        If Not primeiro Then
            json = json & ","
        End If
        
        json = json & "{"
        
        Dim i, fieldCount
        fieldCount = rs.Fields.Count
        
        For i = 0 To fieldCount - 1
            If i > 0 Then
                json = json & ","
            End If
            
            campo = LCase(rs.Fields(i).Name)
            valor = rs.Fields(i).Value
            
            If IsNull(valor) Then
                json = json & """" & campo & """:null"
            Else
                 Select Case VarType(valor)
                    Case vbBoolean
                        If valor Then
                            json = json & """" & campo & """:true"
                        Else
                            json = json & """" & campo & """:false"
                        End If
                    
                    Case vbInteger, vbLong, vbSingle, vbDouble, vbDecimal, vbCurrency
                        valor = Replace(CStr(valor), ",", ".")
                        json = json & """" & campo & """:" & valor
                    
                    Case Else
                        valor = Replace(valor, """", "\""") 
                        json = json & """" & campo & """:""" & valor & """"
                End Select
            End If
        Next
        
        json = json & "}"
        primeiro = False
        rs.MoveNext
    Loop
    
    json = json & "]}"
    RecordSetToJson = json
End Function

Function GetRequestBody()
    Dim bytes, raw, lng
    lng = Request.TotalBytes
    If lng > 0 Then
        bytes = Request.BinaryRead(lng)
        raw = BytesToStr(bytes)
    Else
        raw = ""
    End If
    GetRequestBody = raw
End Function

Function BytesToStr(bytes)
    Dim stream
    Set stream = Server.CreateObject("ADODB.Stream")
    stream.Type = 1
    stream.Open
    stream.Write bytes
    stream.Position = 0
    stream.Type = 2
    stream.Charset = "utf-8"
    BytesToStr = stream.ReadText
    stream.Close
    Set stream = Nothing
End Function

Dim Metodo, Body

Metodo = Request.ServerVariables("REQUEST_METHOD")

Body = GetRequestBody()

%>

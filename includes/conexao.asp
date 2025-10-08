<%

Dim conexao

Set conexao = Server.CreateObject("ADODB.Connection")

Sub AbrirConexao()
    If conexao Is Nothing Then
        Set conexao = Server.CreateObject("ADODB.Connection")
    End If
    If conexao.State = 0 Then
        conexao.Open "Provider=SQLOLEDB;Server=localhost;Database=ASP_CLASSICO;User Id=sa;Password=senhaforte;"
    End If
End Sub

Sub FecharConexao()
    If Not conexao Is Nothing Then
        If conexao.State = 1 Then
            conexao.Close
        End If
        Set conexao = Nothing
    End If
End Sub

%>
<!--#include file="conexao.asp"-->

<%

Dim CabecalhoAuthenticacao
CabecalhoAuthenticacao = Request.ServerVariables("HTTP_AUTHORIZATION")

If CabecalhoAuthenticacao = "" Then
    SendResponse false, "Usuário não logado não tem permissão para acessar essa rota!", "401 Unauthorized"
End If

sql = "SELECT DBO.FN_TOKEN_VALIDO(?) AS USUARIO_ID"

AbrirConexao()

Set comando = Server.CreateObject("ADODB.Command")
Set comando.ActiveConnection = conexao

comando.CommandText = sql
comando.CommandType = 1 

comando.Parameters.Append comando.CreateParameter("@TOKEN",    200, 1, 255, CabecalhoAuthenticacao)

set Linhas = comando.Execute()

If Linhas.EOF Then
    SendResponse false, "Token inválido ou não encontrado!", "401 Unauthorized"
End If

Dim UsuarioId

UsuarioId = Linhas("USUARIO_ID")

If UsuarioId = 0 Or IsNull(UsuarioId) Then
    SendResponse false, "Token Inválido!", "401 Unauthorized"
End If

Linhas.Close
Set Linhas = Nothing
Set comando = Nothing
FecharConexao()

%>
<!--#include file="includes/funcoes.asp"-->
<!--#include file="includes/conexao.asp"-->
<%

Dim usuario, senha

If Metodo <> "POST" Then
    SendResponse false, "Metódo Inválido!", "405 Method Now Allow"
End If

If Body = "" Then
    SendResponse false, "Body Vazio", "400 Bad Request"
End If

usuario = GetJsonValue(Body, "usuario")
senha   = GetJsonValue(Body, "senha")

If usuario = "" Or senha = "" Then
    SendResponse false, "Campos obrigatórios não foram informados!", "400 Bad Request"
End If

sql = "EXEC SP_LOGAR_USUARIO ?, ?"

AbrirConexao()

Set comando = Server.CreateObject("ADODB.Command")
Set comando.ActiveConnection = conexao

comando.CommandText = sql
comando.CommandType = 1 

comando.Parameters.Append comando.CreateParameter("@USUARIO",    200, 1, 30, usuario)
comando.Parameters.Append comando.CreateParameter("@SENHA", 200, 1, 255,  senha)

set Linhas = comando.Execute()

If Linhas.Eof Then
    SendResponse false, "Usuário ou Senha inválidos!", "400 Bad Request"
End If 

If Linhas("TOKEN") = "" Or IsNull(Linhas("TOKEN")) Then
    SendResponse false, "Usuário ou Senha inválidos!", "400 Bad Request"
Else
    SendResponse true, Linhas("TOKEN"), "200 Ok"
End If

Linhas.Close
Set Linhas = Nothing
Set comando = Nothing
FecharConexao()
%>
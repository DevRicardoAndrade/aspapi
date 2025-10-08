<!--#include file="includes/funcoes.asp"-->
<!--#include file="includes/conexao.asp"-->

<%

Dim usuario, email, senha, nome

If Metodo <> "POST" Then
    SendResponse false, "Metódo Inválido!", "405 Method Now Allow"
End If

If Body = "" Then
    SendResponse false, "Body Vazio", "400 Bad Request"
End If

usuario = GetJsonValue(Body, "usuario")
email   = GetJsonValue(Body, "email")
senha   = GetJsonValue(Body, "senha")
nome    = GetJsonValue(Body, "nome")

If usuario = "" Or senha = "" Or email = "" Or nome = "" Then
    SendResponse false, "Campos obrigatórios não foram informados!", "400 Bad Request"
End If

sql = "EXEC SP_INSERIR_USUARIO ?, ?, ?, ?"

AbrirConexao()

Set comando = Server.CreateObject("ADODB.Command")
Set comando.ActiveConnection = conexao

comando.CommandText = sql
comando.CommandType = 1 

comando.Parameters.Append comando.CreateParameter("@NOME",    200, 1, 255, nome)
comando.Parameters.Append comando.CreateParameter("@USUARIO", 200, 1, 30,  usuario)
comando.Parameters.Append comando.CreateParameter("@SENHA",   200, 1, 255, senha)
comando.Parameters.Append comando.CreateParameter("@EMAIL",   200, 1, 255, email)

comando.Execute

If Err.Number <> 0 Then
    SendResponse false, Err.Description, "500 Internal Server Error"
Else
    SendResponse true, "Usuário registrado com sucesso!", "201 Created"
End If

Set comando = Nothing
FecharConexao()

%>

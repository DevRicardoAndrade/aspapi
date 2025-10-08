<!--#include file="includes/funcoes.asp"-->
<!--#include file="includes/autenticacao.asp"-->
<%
Response.AddHeader "Access-Control-Allow-Origin", "*"
Response.AddHeader "Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS"
Response.AddHeader "Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With, Accept, Origin"
Response.AddHeader "Access-Control-Allow-Credentials", "true"

Sub CadastrarProduto()
    If Body = "" Then
        SendResponse false, "Body Vazio", "400 Bad Request"
    End If
    Dim nome, slug, descricao, preco, estoque, ativo

    nome = GetJsonValue(Body, "nome")
    descricao = GetJsonValue(Body, "descricao")
    slug = GetJsonValue(Body, "slug")
    preco = GetJsonDecimal(Body, "preco")
    estoque = GetJsonDecimal(Body, "estoque")
    ativo = GetJsonInt(Body, "ativo")
    
    If nome = "" Or slug = "" Then
        SendResponse false, "Nome e slug são obrigatórios!", "400 Bad Request"
    End If
    
    If preco = "" Or IsNull(preco) Then
        SendResponse false, "Preço é obrigatório!", "400 Bad Request"
    End If
    
    If estoque = "" Or IsNull(estoque) Then
        estoque = 0
    End If
    
    If ativo = "" Or IsNull(ativo) Then
        ativo = 1
    End If

    sql = "EXEC SP_INSERIR_PRODUTO ?, ?, ?, ?, ?, ?, ?"

    AbrirConexao()

    Set comando = Server.CreateObject("ADODB.Command")
    Set comando.ActiveConnection = conexao

    comando.CommandText = sql
    comando.CommandType = 1 

    comando.Parameters.Append comando.CreateParameter("@NOME",    200, 1, 255, nome)
    comando.Parameters.Append comando.CreateParameter("@SLUG",    200, 1, 255, slug)
    comando.Parameters.Append comando.CreateParameter("@DESCRICAO",    200, 1, 255, descricao)

    comando.Parameters.Append comando.CreateParameter("@PRECO",    5, 1, 8, preco)
    comando.Parameters.Append comando.CreateParameter("@ESTOQUE",    5, 1, 8, estoque)
    
    comando.Parameters.Append comando.CreateParameter("@ATIVO",    11, 1, 1, ativo)
    comando.Parameters.Append comando.CreateParameter("@USUARIO_ID",    3, 1, 4, UsuarioId)

    comando.Execute

    If Err.Number <> 0 Then
        SendResponse false, Err.Description, "500 Internal Server Error"
    Else
        SendResponse true, "Produto cadastrado com sucesso!", "201 Created"
    End If

    Set comando = Nothing
    FecharConexao()
End Sub

Sub ListarProdutos()
    Dim slug, nome, preco, estoque, ativo

    slug = GetQueryParam("slug", "")
    nome = GetQueryParam("nome", "")
    preco = GetQueryParam("preco", "")
    estoque = GetQueryParam("estoque", "")
    ativo = GetQueryParam("ativo", "")

    sql = "EXEC SP_LISTAR_PRODUTOS ?, ?, ?, ?, ?"

    AbrirConexao()

    Set comando = Server.CreateObject("ADODB.Command")
    Set comando.ActiveConnection = conexao

    comando.CommandText = sql
    comando.CommandType = 1 

    If preco = "" Or IsNull(preco) Then 
        preco = 0
    Else
        preco = CDbl(Replace(preco, ".", ","))
    End If
    If estoque = "" Or IsNull(estoque) Then 
        estoque = 0
    Else
        estoque = CDbl(Replace(estoque, ".", ","))
    End If
    If ativo = "" Or IsNull(ativo) Then ativo = 0
    
    comando.Parameters.Append comando.CreateParameter("@SLUG",    200, 1, 255, slug)
    comando.Parameters.Append comando.CreateParameter("@NOME",    200, 1, 255, nome)
    comando.Parameters.Append comando.CreateParameter("@PRECO",    5, 1, 8, CDbl(preco))
    comando.Parameters.Append comando.CreateParameter("@ESTOQUE",    5, 1, 8, CDbl(estoque))
    comando.Parameters.Append comando.CreateParameter("@ATIVO",    11, 1, 1, CInt(ativo))

    Set Linhas = comando.Execute()

    If Linhas.EOF Then
        SendResponse false, "Produto não encontrado!", "404 Not Found"
    Else
        Dim json
        json = RecordSetToJson(Linhas, "produtos")
        
        Response.ContentType = "application/json"
        Response.Write json
        Response.End
    End If
    
    Linhas.Close
    Set Linhas = Nothing
    Set comando = Nothing
    FecharConexao()
End Sub

Sub DeletarProduto()

    Dim id

    id = GetJsonInt(Body, "id")

    sql = "SELECT TOP 1 A.ID FROM PRODUTOS A WITH(NOLOCK) WHERE ID = ?"

    AbrirConexao()

    Set comando = Server.CreateObject("ADODB.Command")
    Set comando.ActiveConnection = conexao

    comando.CommandText = sql
    comando.CommandType = 1 

    comando.Parameters.Append comando.CreateParameter("@PRODUTO_ID",    3, 1, 4, CInt(id))

    Set Linhas = comando.Execute()

    If Linhas.EOF Then
        SendResponse false, "Produto não encontrado!", "404 Not Found"
    End If
    
    Linhas.Close
    Set Linhas = Nothing
    Set comando = Nothing

    sql = "EXEC SP_DELETAR_PRODUTO ?"

    Set comando = Server.CreateObject("ADODB.Command")
    Set comando.ActiveConnection = conexao

    comando.CommandText = sql
    comando.CommandType = 1 

    comando.Parameters.Append comando.CreateParameter("@PRODUTO_ID",    3, 1, 4, CInt(id))

    Set Linhas = comando.Execute()

    If Err.Number <> 0 Then
        SendResponse false, Err.Description, "500 Internal Server Error"
    Else
        SendResponse true, "Produto deletado com sucesso!", "200 Created"
    End If

    Set comando = Nothing
    FecharConexao()  
End Sub

Sub AtualizarProduto()
    If Body = "" Then
        SendResponse false, "Body Vazio", "400 Bad Request"
    End If
    Dim id, nome, slug, descricao, preco, estoque, ativo

    id = GetJsonInt(Body, "id")
    nome = GetJsonValue(Body, "nome")
    descricao = GetJsonValue(Body, "descricao")
    slug = GetJsonValue(Body, "slug")
    preco = GetJsonDecimal(Body, "preco")
    estoque = GetJsonDecimal(Body, "estoque")
    ativo = GetJsonInt(Body, "ativo")

    If nome = "" Or slug = "" Then
        SendResponse false, "Nome e slug são obrigatórios!", "400 Bad Request"
    End If
    
    If preco = "" Or IsNull(preco) Then
        SendResponse false, "Preço é obrigatório!", "400 Bad Request"
    End If

    If id = "" Or IsNull(id) Then
        SendResponse false, "Id é obrigatório!", "400 Bad Request"
    End If

    If estoque = "" Or IsNull(estoque) Then
        estoque = 0
    End If
    
    If ativo = "" Or IsNull(ativo) Then
        ativo = 1
    End If

    sql = "SELECT TOP 1 A.ID FROM PRODUTOS A WITH(NOLOCK) WHERE ID = ?"

    AbrirConexao()

    Set comando = Server.CreateObject("ADODB.Command")
    Set comando.ActiveConnection = conexao

    comando.CommandText = sql
    comando.CommandType = 1 

    comando.Parameters.Append comando.CreateParameter("@PRODUTO_ID",    3, 1, 4, CInt(id))

    Set Linhas = comando.Execute()

    If Linhas.EOF Then
        SendResponse false, "Produto não encontrado!", "404 Not Found"
    End If
    
    Linhas.Close
    Set Linhas = Nothing
    Set comando = Nothing

    sql = "EXEC SP_ATUALIZAR_PRODUTO ?, ?, ?, ?, ?, ?, ?, ?"

    Set comando = Server.CreateObject("ADODB.Command")
    Set comando.ActiveConnection = conexao

    comando.CommandText = sql
    comando.CommandType = 1 

    comando.Parameters.Append comando.CreateParameter("@ID",    3, 1, 4, id)
    comando.Parameters.Append comando.CreateParameter("@NOME",    200, 1, 255, nome)
    comando.Parameters.Append comando.CreateParameter("@SLUG",    200, 1, 255, slug)
    comando.Parameters.Append comando.CreateParameter("@DESCRICAO",    200, 1, 255, descricao)

    comando.Parameters.Append comando.CreateParameter("@PRECO",    5, 1, 8, preco)
    comando.Parameters.Append comando.CreateParameter("@ESTOQUE",    5, 1, 8, estoque)
    
    comando.Parameters.Append comando.CreateParameter("@ATIVO",    11, 1, 1, ativo)
    comando.Parameters.Append comando.CreateParameter("@USUARIO_ID",    3, 1, 4, UsuarioId)

    comando.Execute

    If Err.Number <> 0 Then
        SendResponse false, Err.Description, "500 Internal Server Error"
    Else
        SendResponse true, "Produto atualizado com sucesso!", "200 Ok"
    End If

    Set comando = Nothing
    FecharConexao()    

End Sub

Select Case Metodo
    Case "POST"
        CadastrarProduto
    Case "GET"
        ListarProdutos
    Case "PUT"
        AtualizarProduto
    Case "DELETE"
        DeletarProduto
End Select

%>
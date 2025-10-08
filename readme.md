# API ASP Clássico

API simples em **ASP Clássico** para autenticação e gerenciamento de produtos.

---

## Endpoints

### Autenticação

#### **1. Login**
**URL:** `/entrar.asp`  
**Método:** `POST`  
**Parâmetros (JSON):**
```json
Body Request
{
    "usuario": "string",
    "senha": "string"
}

Retorno 200 Ok:
{
    "sucesso": true,
    "mensagem": "string-token",
}

Retorno 400 Bad Request:
{
    "sucesso": false,
    "mensagem": "Usuário ou Senha inválidos!",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Body Vazio",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Campos obrigatórios não foram informados!",
}

Retorno 405 Method Now Allow
{
    "sucesso": false,
    "mensagem": "Metódo Inválido!",
}

Retorno 500 Internal Server Error:
{
    "sucesso": false,
    "mensagem": "string-error",
}
```

#### **2. Registro**
**URL:** `/registro.asp`  
**Método:** `POST`  
**Parâmetros (JSON):**
```json
Body Request
{
    "nome": "string",
    "email": "string",
    "usuario": "string",
    "senha": "string"
}

Retorno 201 Created:
{
    "sucesso": true,
    "mensagem": "Usuário registrado com sucesso!",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Body Vazio",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Campos obrigatórios não foram informados!",
}

Retorno 405 Method Now Allow
{
    "sucesso": false,
    "mensagem": "Metódo Inválido!",
}

Retorno 500 Internal Server Error:
{
    "sucesso": false,
    "mensagem": "string-error",
}
```

#### **2. Produtos**
**URL:** `/produtos.asp`  
**Métodos:** `POST, PUT, DELETE, GET`  
**Parâmetros (JSON):**

**GET**
```json
Query Params (Opicional) "?nome=string&slug=string&preco=0.0&estoque=0.0&ativo=1"

Retorno 200 Ok
{
  "sucesso": true,
  "produtos": [
    {
      "id": 1,
      "nome": "string",
      "slug": "string",
      "descricao": "string",
      "preco": 0.0,
      "estoque": 0.0,
      "ativo": 1,
      "usuario_inclusao": "string",
      "usuario_alteracao": null || "string"
    }
  ]
}

Retorno 404 Not Found
{
    "sucesso": false,
    "mensagem": "Produto não encontrado!",
}
```
**POST**
```json
Body Request
{
    "nome": "string",
    "slug": "string",
    "descricao": "string",
    "preco": 0.0,
    "estoque": 0.0,
    "ativo": 1
}

Retorno 201 Created:
{
    "sucesso": true,
    "mensagem": "Produto cadastrado com sucesso!",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Nome e slug são obrigatórios!",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Preço é obrigatório!",
}
```
**PUT**
```json
Body Request
{
    "id": 0,
    "nome": "string",
    "slug": "string",
    "descricao": "string",
    "preco": 0.0,
    "estoque": 0.0,
    "ativo": 1
}

Retorno 200 Ok:
{
    "sucesso": true,
    "mensagem": "Produto atualizado com sucesso!",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Nome e slug são obrigatórios!",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Preço é obrigatório!",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Id é obrigatório!",
}

Retorno 404 Not Found
{
    "sucesso": false,
    "mensagem": "Produto não encontrado!",
}

```
**DELETE**
```json
Body Request
{
    "id": 0
}

Retorno 200 Ok:
{
    "sucesso": true,
    "mensagem": "Produto deletado com sucesso!",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Id é obrigatório!",
}

Retorno 404 Not Found
{
    "sucesso": false,
    "mensagem": "Produto não encontrado!",
}
```

**Retorno de erros gerais**
```json
Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Body Vazio",
}

Retorno 400 Bad Request
{
    "sucesso": false,
    "mensagem": "Campos obrigatórios não foram informados!",
}

Retorno 405 Method Now Allow
{
    "sucesso": false,
    "mensagem": "Metódo Inválido!",
}

Retorno 500 Internal Server Error:
{
    "sucesso": false,
    "mensagem": "string-error",
}
```

## Como Rodar a Aplicação ASP Clássico

Siga os passos abaixo para configurar e executar a aplicação localmente:

1. **Instale o servidor ASP Clássico**
   - No Windows, instale o **IIS** com suporte a ASP Clássico.

2. **Preparar Bando de Dados**
    - Altere a string de conexão do arquivo /includes/conexao.asp
    - Rode os script da pasta sql no seu banco de dados SQL Server

3. **Copie os arquivos da aplicação**
   - Coloque todos os arquivos do projeto na pasta do servidor.
   - Exemplo de caminho no IIS:  
     ```
     C:\inetpub\wwwroot\aspapi
     ```

4. **Configure permissões**
   - Garanta que a pasta tenha permissão de leitura e execução de scripts ASP para o usuário do servidor.

5. **Acesse a aplicação pelo navegador**
   - Abra o navegador e acesse:
     ```
     http://localhost:81/
     ```


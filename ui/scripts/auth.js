function enableRoute(route){
    const routes = ['ui/cadastro/', '/ui/cadastro', '/ui/cadastro/',
        'ui/', '/ui/', 'ui'
    ]
    return routes.includes(route)
}
async function validateAuth() {
    const validate = {redirect: false, route: ''}
    const token = localStorage.getItem('token')
    try{
        if((!token || token == '')
        &&
        !enableRoute(window.location.pathname)
        )
        {   
            throw new Error('Ocorreu um erro ao validar token!')
        }

        const res = await fetch('http://localhost:81/validar_login.asp',
            {
                headers:{
                    'Authorization': token,
                    'Content-Type': 'application/json' 
                },
                method: 'GET'
            }
        )
        const data = await res.json()
        if(data.sucesso){
            if( enableRoute(window.location.pathname))
                validate.redirect = true
                validate.route = '/ui/produtos'
        }
        else
        {
            if(enableRoute(window.location.pathname))
                return
            throw new Error('Ocorreu um erro ao validar token!')
        }
    }
    catch{
        alert('Ocorreu um erro ao validar processo de login! Faça login novamente!')
        localStorage.removeItem('token')
        validate.redirect = true
        validate.route = '/ui'
    }
    finally{
        if(validate.redirect){
            window.location.href = validate.route
        }
    }

}
document.addEventListener('DOMContentLoaded', validateAuth)
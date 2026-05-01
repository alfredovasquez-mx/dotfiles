function vpnadd --description "Agrega un perfil VPN de Pritunl usando URI"
    set -l client /Applications/Pritunl.app/Contents/Resources/pritunl-client
    set -l uri $argv[1]

    if not test -x "$client"
        echo "❌ Pritunl client no encontrado"
        return 1
    end

    if test -z "$uri"
        echo "❌ Uso: vpnadd pritunl://servidor/path"
        return 1
    end

    echo "➕ Agregando perfil VPN..."
    $client add "$uri"
    
    $client list
end

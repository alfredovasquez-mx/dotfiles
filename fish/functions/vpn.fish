function vpn --description "Muestra el estado de las conexiones VPN de Pritunl"
    set -l client /Applications/Pritunl.app/Contents/Resources/pritunl-client
    
    if not test -x "$client"
        echo "❌ Pritunl client no encontrado"
        return 1
    end

    $client list
end

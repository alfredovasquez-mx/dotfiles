function vpnstart --description "Conecta a un perfil VPN de Pritunl"
    set -l client /Applications/Pritunl.app/Contents/Resources/pritunl-client
    set -l profile_id $argv[1]
    set -l timeout 60

    if not test -x "$client"
        echo "❌ Pritunl client no encontrado"
        return 1
    end

    if test -z "$profile_id"
        set profile_id ($client list 2>/dev/null | awk -F'|' '/^\|[^-]/ && NR>2 {gsub(/ /, "", $2); print $2; exit}')
        if test -z "$profile_id"
            echo "❌ No hay perfiles VPN configurados"
            return 1
        end
    end

    echo "🔐 Conectando a VPN..."
    set -l output ($client start "$profile_id" 2>&1)
    
    # Extraer y abrir URL SSO si existe
    set -l sso_url (echo "$output" | grep -oE 'https://[^ ]+')
    if test -n "$sso_url"
        echo "🌐 Abriendo autenticación SSO..."
        open "$sso_url"
    end

    # Esperar hasta que conecte o timeout
    echo -n "⏳ Esperando conexión"
    set -l elapsed 0
    while test $elapsed -lt $timeout
        set -l status ($client list 2>/dev/null | awk -F'|' '/^\|[^-]/ && NR>2 {gsub(/ /, "", $7); print $7; exit}')
        if test -n "$status" -a "$status" != "-"
            echo ""
            echo "✅ Conectado: $status"
            $client list
            return 0
        end
        echo -n "."
        sleep 2
        set elapsed (math $elapsed + 2)
    end

    echo ""
    echo "⚠️  Timeout esperando conexión. Estado actual:"
    $client list
    return 1
end

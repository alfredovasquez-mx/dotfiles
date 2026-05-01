function vpnstop --description "Desconecta un perfil VPN de Pritunl"
    set -l client /Applications/Pritunl.app/Contents/Resources/pritunl-client
    set -l profile_id $argv[1]

    if not test -x "$client"
        echo "❌ Pritunl client no encontrado"
        return 1
    end

    if test -z "$profile_id"
        # Si no se pasa ID, usar el primero disponible
        set profile_id ($client list 2>/dev/null | awk -F'|' '/^\|[^-]/ && NR>2 {gsub(/ /, "", $2); print $2; exit}')
        if test -z "$profile_id"
            echo "❌ No hay perfiles VPN configurados"
            return 1
        end
    end

    echo "🔓 Desconectando VPN..."
    $client stop "$profile_id"
    
    sleep 1
    $client list
end

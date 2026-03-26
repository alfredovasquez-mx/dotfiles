function awswho --description "Muestra el perfil AWS activo y su cuenta"
    set p $argv[1]

    if test -z "$p"
        set p $AWS_PROFILE
    end

    if test -z "$p"
        echo "⛔ No hay perfil activo (define AWS_PROFILE o pásalo como argumento)."
        return 1
    end

    set region (aws configure get region --profile "$p" 2>/dev/null)
    set role (aws configure get sso_role_name --profile "$p" 2>/dev/null)
    set acct (env AWS_SDK_LOAD_CONFIG=1 aws sts get-caller-identity --profile "$p" --query Account --output text 2>/dev/null)

    if test -z "$acct" -o "$acct" = "None"
        echo "⛔ No hay sesión SSO activa para '$p'. Ejecuta: aws sso login --profile $p"
        return 1
    end

    echo "✅ Perfil: $p | Cuenta: $acct | Rol: "(test -n "$role"; and echo $role; or echo "desconocido")" | Región: "(test -n "$region"; and echo $region; or echo "desconocida")
end

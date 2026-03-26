function awsprofiles --description "Lista perfiles AWS con estado SSO"
    set profiles (aws configure list-profiles 2>/dev/null)
    if test (count $profiles) -eq 0
        echo "⛔ No hay perfiles configurados en ~/.aws/config"
        return 1
    end

    for p in $profiles
        test -z "$p"; and continue

        set region (aws configure get region --profile "$p" 2>/dev/null)
        set role (aws configure get sso_role_name --profile "$p" 2>/dev/null)
        set acct (env AWS_SDK_LOAD_CONFIG=1 aws sts get-caller-identity --profile "$p" --query Account --output text 2>/dev/null)

        if test -n "$acct"; and test "$acct" != "None"
            echo "✅ Perfil: $p | Cuenta: $acct | Rol: "(test -n "$role"; and echo $role; or echo "desconocido")" | Región: "(test -n "$region"; and echo $region; or echo "desconocida")
        else
            echo "⏸️ Perfil: $p | (sin sesión SSO) | Rol: "(test -n "$role"; and echo $role; or echo "desconocido")" | Región: "(test -n "$region"; and echo $region; or echo "desconocida")
        end
    end
end

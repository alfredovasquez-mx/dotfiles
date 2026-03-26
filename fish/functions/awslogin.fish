function awslogin --description "Activa perfil AWS y hace login SSO si hace falta"
    set p $argv[1]
    if test -z "$p"
        set p dev   # cámbialo si quieres otro default
    end

    set profiles (aws configure list-profiles 2>/dev/null)
    if not contains -- "$p" $profiles
        echo "❌ El perfil '$p' no existe en ~/.aws/config"
        return 1
    end

    set -gx AWS_PROFILE "$p"
    set -gx AWS_DEFAULT_PROFILE "$p"
    set -gx AWS_SDK_LOAD_CONFIG 1

    set reg (aws configure get region --profile "$p" 2>/dev/null)
    if test -n "$reg"
        set -gx AWS_REGION "$reg"
        set -gx AWS_DEFAULT_REGION "$reg"
    end

    if not aws sts get-caller-identity --profile "$p" >/dev/null 2>&1
        echo "🔐 Iniciando sesión SSO para perfil '$p'..."
        aws sso login --profile "$p"
        or return $status
    end

    set acct (aws sts get-caller-identity --profile "$p" --query Account --output text 2>/dev/null)
    set role (aws configure get sso_role_name --profile "$p" 2>/dev/null)

    echo "✅ Perfil: $p | Cuenta: $acct | Rol: "(test -n "$role"; and echo $role; or echo "desconocido")" | Región: "(test -n "$AWS_REGION"; and echo $AWS_REGION; or echo "no definida")
end

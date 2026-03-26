function awslogout --description "Cierra sesión SSO y limpia variables AWS"
    echo "🔓 Cerrando sesión SSO..."
    aws sso logout >/dev/null 2>&1

    rm -f ~/.aws/sso/cache/* 2>/dev/null

    set -e AWS_PROFILE
    set -e AWS_DEFAULT_PROFILE
    set -e AWS_REGION
    set -e AWS_DEFAULT_REGION
    set -e AWS_ACCESS_KEY_ID
    set -e AWS_SECRET_ACCESS_KEY
    set -e AWS_SESSION_TOKEN
    set -e AWS_SDK_LOAD_CONFIG

    echo "✅ Sesión cerrada y caché limpiado."
end

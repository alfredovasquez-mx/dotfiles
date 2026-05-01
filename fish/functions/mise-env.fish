function mise-env
    if set -q MISE_ENV
        echo "MISE_ENV=$MISE_ENV"
    else
        echo "MISE_ENV no configurado"
        echo "Usa: mise-dev | mise-stg | mise-prod"
    end
end

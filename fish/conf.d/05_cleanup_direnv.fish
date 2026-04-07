if not command -q direnv
    for fn in __direnv_export_eval __direnv_cd_hook __direnv_hook
        if functions -q $fn
            functions -e $fn
        end
    end
end

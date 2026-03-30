function fish_mode_prompt
    switch $fish_bind_mode
        case default
            set_color 8ba4b0 --bold
            echo -n "N "
        case visual
            set_color c4b28a --bold
            echo -n "V "
        case replace_one
            set_color c4746e --bold
            echo -n "R "
    end

    set_color normal
end

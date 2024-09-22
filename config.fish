function __fish_prompt_orig --description 'Informative prompt with Git status'
    # Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    if functions -q fish_is_root_user; and fish_is_root_user
        printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
                                                         and set_color $fish_color_cwd_root
                                                         or set_color $fish_color_cwd) \
            (prompt_pwd) (set_color normal)
    else
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color --bold $fish_color_status)
        set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        # Display the current time, user, host, and working directory
        printf '[%s] %s%s@%s %s%s' (date "+%H:%M:%S") (set_color brblue) $USER (prompt_hostname) (set_color $fish_color_cwd) $PWD

        # Display the git status here
        if git_is_repo
            printf " %s(%s" (set_color green) (git_branch_name)
            git_is_dirty && printf "%s✗" (set_color red)
            git_is_staged && printf "%s+" (set_color yellow)
            #git_is_touched && printf "%s?" (set_color magenta)
            git status --porcelain | grep -q '^??' && printf "%s?" (set_color magenta)
            printf "%s) " (set_color green)
        end

        printf '%s %s%s%s \n> ' (set_color normal) $pipestatus_string (set_color normal)
    end
end

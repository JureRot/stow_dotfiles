#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Created by `pipx` on 2025-12-02 20:11:28
export PATH="$PATH:/home/neumnotele/.local/bin"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/neumnotele/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/neumnotele/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<

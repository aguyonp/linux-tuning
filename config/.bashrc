# Colorful prompt
export PS1='\[\e[1;36m\]\u\[\e[m\]@\[\e[1;32m\]\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\]\$ '

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]\$ "

# Use colors in terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# History control
export HISTCONTROL=ignoreboth:erasedups  # no duplicate entries
export HISTSIZE=1000                     # big big history
export HISTFILESIZE=10000                # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# A function to quickly create a directory and navigate into it
mkcd() {
    mkdir -p -- "$1" &&
    cd -P -- "$1"
}

# A function to extract archived files
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# A function to get your public IP address
myip() {
    curl http://ipecho.net/plain; echo
}

# A function to quickly search through your command history
h() {
    history | ag $1
}

# Display system information
figlet $(hostname)

echo -e "
\e[1;34m++++++++++++++++ SYSTEM ++++++++++++++++++\e[0m
\e[1;36m+ Hostname = $(hostname)\e[0m
\e[1;36m+ Adresse(s) IP = $(hostname -I | tr ' ' ', ')\e[0m
\e[1;36m+ OS = $(lsb_release -ds)\e[0m
\e[1;36m+ Kernel = $(uname -r)\e[0m
\e[1;36m+ Uptime = $(uptime -p)\e[0m
\e[1;36m+ RAM = $(free -h --si | awk '/^Mem/ {printf "%s/%s total", $3, $2}')\e[0m
\e[1;36m+ Ports in use = $(ss -t -a | awk '/LISTEN/ {print $4}' | awk -F':' '{print $2}' | tr '\n' ',')\e[0m
$(
# Check if Docker is installed and display the number of running containers
if command -v docker &> /dev/null; then
  echo -e "\e[1;36m+ Docker running CT = $(docker ps -q | wc -l)\e[0m"
fi)
\e[1;34m++++++++++++++++ SYSTEM ++++++++++++++++++\e[0m
"
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

# Display Git branch in prompt.
parse_git_branch() {
    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')
    [ ! -z "$branch" ] && echo -e "\[\033[33m\]$branch\[\033[m\]"
}

PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[m\]\$(parse_git_branch)\$ "

# Enable colors in terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# History control
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=1000
export HISTFILESIZE=10000
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable color support for ls and add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# Function to quickly create a directory and navigate into it
mkcd() {
    mkdir -p -- "$1" && cd -P -- "$1"
}

# Function to extract archived files
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xvjf "$1" ;;
            *.tar.gz) tar xvzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xvf "$1" ;;
            *.tbz2) tar xvjf "$1" ;;
            *.tgz) tar xvzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Function to get your public IP address
myip() {
    curl http://ifconfig.me/ip; echo
}

# Function to quickly search through your command history
h() {
    history | ag "$1"
}

# Display system information using figlet
figlet "$(hostname)"

# Function to display system information
system_info() {
    echo -e "\e[1;34m++++++++++++++++ SYSTEM ++++++++++++++++++\e[0m"
    echo -e "\e[1;36m+ Hostname = $(hostname)\e[0m"
    echo -e "\e[1;36m+ IP Address(es) = $(hostname -I | tr ' ' ', ')\e[0m"
    echo -e "\e[1;36m+ Public IP = $(curl http://ifconfig.me/ip; echo)\e[0m"
    echo -e "\e[1;36m+ OS = $(lsb_release -ds)\e[0m"
    echo -e "\e[1;36m+ Kernel = $(uname -r)\e[0m"
    echo -e "\e[1;36m+ Uptime = $(uptime -p)\e[0m"
    echo -e "\e[1;36m+ RAM = $(free -h --si | awk '/^Mem/ {printf "%s/%s total", $3, $2}')\e[0m"
    echo -e "\e[1;36m+ Ports in use = $(ss -t -a | awk '/LISTEN/ {print $4}' | awk -F':' '{print $2}' | tr '\n' ',')\e[0m"
    
    # Check if Docker is installed and display the number of running containers
    if command -v docker &> /dev/null; then
        echo -e "\e[1;36m+ Docker running CT = $(docker ps -q | wc -l)\e[0m"
    fi
    
    echo -e "\e[1;34m++++++++++++++++ SYSTEM ++++++++++++++++++\e[0m"
}

system_info

# Function to list open network connections
netstat_info() {
    echo -e "\e[1;34m++++++++++++ OPEN NETWORK CONNECTIONS ++++++++++++\e[0m"
    netstat -an | grep -e "Proto\|LISTEN"
    echo -e "\e[1;34m++++++++++++ OPEN NETWORK CONNECTIONS ++++++++++++\e[0m"
}

# Alias for a colored and formatted ls command
alias ls='ls --color=auto -lh'

# Help function to explain aliases and functions
help() {
    echo -e "\e[1;33m+++++++++++++++ CUSTOM BASHRC HELP +++++++++++++++\e[0m"
    echo -e "\e[1;36mAlias 'll':\e[0m List all files in long format with details"
    echo -e "\e[1;36mAlias 'la':\e[0m List all files, including hidden ones"
    echo -e "\e[1;36mAlias 'l':\e[0m List files in a formatted way"
    echo -e "\e[1;36mAlias '..':\e[0m Change to the parent directory"
    echo -e "\e[1;36mFunction 'mkcd':\e[0m Create a directory and navigate into it"
    echo -e "\e[1;36mFunction 'extract':\e[0m Extract archived files"
    echo -e "\e[1;36mFunction 'myip':\e[0m Get your public IP address"
    echo -e "\e[1;36mFunction 'h':\e[0m Search through command history"
    echo -e "\e[1;36mCommand 'ls':\e[0m List files with color and formatting"
    echo -e "\e[1;36mFunction 'system_info':\e[0m Display system information"
    echo -e "\e[1;36mFunction 'netstat_info':\e[0m List open network connections"
    echo -e "\e[1;33m+++++++++++++++ CUSTOM BASHRC HELP +++++++++++++++\e[0m"
}

echo "*** Use help command to see alias and functions ***"

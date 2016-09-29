#zstyle ':completion:*' completer _complete _ignored

#autoload -Uz compinit
#compinit

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="terminalparty"
#ZSH_THEME="robbyrussell"
source $HOME/.oh-my-zsh/oh-my-zsh.sh
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

ZSH_THEME_NVM_PROMPT_PREFIX="%B⬡%b "
ZSH_THEME_NVM_PROMPT_SUFFIX=""

### Git [±master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_bold[green]%}±%{$reset_color%}%{$fg_bold[black]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[#a2ac00]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"

bureau_git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

bureau_git_status () {
  _INDEX=$(command git status --porcelain -b 2> /dev/null)
  _STATUS=""
  if $(echo "$_INDEX" | grep '^[AMRD]. ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi
  if $(echo "$_INDEX" | grep '^.[MTD] ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi
  if $(echo "$_INDEX" | grep -E '^\?\? ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi
  if $(echo "$_INDEX" | grep '^UU ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
  fi
  if $(echo "$_INDEX" | grep '^## .*ahead' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$_INDEX" | grep '^## .*behind' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if $(echo "$_INDEX" | grep '^## .*diverged' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  echo $_STATUS
}

bureau_git_prompt () {
  local _branch=$(bureau_git_branch)
  local _status=$(bureau_git_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$ZSH_THEME_GIT_PROMPT_PREFIX$_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi
    _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}


_PATH="%{$fg_bold[black]%}%~%{$reset_color%}"

if [[ $EUID -eq 0 ]]; then
  _USERNAME="%{$fg_bold[red]%}%n"
  _LIBERTY="%{$fg[red]%}#"
else
  _USERNAME="%{$fg_bold[black]%}%n"
  _LIBERTY="%{$fg[green]%}$"
fi
_USERNAME="$_USERNAME%{$reset_color%}@%m"
_LIBERTY="$_LIBERTY%{$reset_color%}"


get_space () {
  local STR=$1$2
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}} 
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 1))
  
  for i in {0..$LENGTH}
    do
      SPACES="$SPACES "
    done

  echo $SPACES
}

_1LEFT="$_USERNAME $_PATH"
_1RIGHT="[%*] "

bureau_precmd () {
#  _1SPACES=`get_space $_1LEFT $_1RIGHT`
#  print
#  print -rP "$_1LEFT$_1SPACES$_1RIGHT"
}

setopt prompt_subst
#PROMPT='> $_LIBERTY '
#RPROMPT='$(nvm_prompt_info) $(bureau_git_prompt)'

autoload -U add-zsh-hook
add-zsh-hook precmd bureau_precmd



HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=5000
#bindkey -e

setopt APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_ALL_DUPS

export LC_ALL='ru_RU.UTF-8'
export LANG='ru_RU.UTF-8'
export MM_CHARSET=UTF-8

bindkey '\e[3~' delete-char # del
bindkey ';5D' backward-word # ctrl+left
bindkey ';5C' forward-word #ctrl+right
bindkey "\e[3~" delete-char
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey '^R' history-incremental-search-backward

autoload -U compinit promptinit
#compinit
compinit -u
promptinit;

if [[ $EUID == 0 ]]
then
	PROMPT=$'%{\e[1;31m%}%n@%m %{\e[1;34m%}%~ #%{\e[0m%} ' # user dir %
else
	PROMPT=$'%{\e[1;32m%}%n@%m %{\e[1;34m%}%~ %#%{\e[0m%} ' # root dir #
fi
RPROMPT=$'%{\e[1;34m%}$(bureau_git_prompt) %T%{\e[0m%}' # right prompt with time

#alias ls='ls --color=auto'
#alias grep='grep --colour=auto'

zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

export PAGER=less
export EDITOR=vim
alias svim="sudo -E vim"
alias s="sudo -sE"
alias grep="grep --color"
alias ifstat="systat -ifstat 1 scale mbit "
alias sshprepare=eval \`ssh-agent\`\; ssh-add
alias gst="git status"
alias balancer="sudo -E make -C /usr/local/balancers/"
alias router="sudo -E make -C /usr/local/routers/"
#поиск в истории команд
autoload -U predict-on
zle -N predict-on
zle -N predict-off
#bindkey '^X^Z' predict-on
#bindkey '^Z' predict-off
bindkey -M isearch '^[OB' history-incremental-search-forward
bindkey -M isearch '^[OA' history-incremental-search-backward 

#color stderr stdout
exec 2>>(while read line; do
  print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done &)


#Сокращённый ввод имён директорий (/u/l/p вместо /user/local/ports)
autoload -U compinit
setopt autocd

#Корректировка ошибок при вводе команды
setopt CORRECT_ALL
#SPROMPT=”Вы хотели ввести %r вместо %R? ([Y]es/[N]o/[E]dit/[A]bort) ”



#export VTYSH_PAGER=less


# save each command's beginning timestamp and the duration to the history file
setopt extended_history

# check for version/system
# check for versions (compatibility reasons)
is4(){
    [[ $ZSH_VERSION == <4->* ]] && return 0
    return 1
}

is41(){
    [[ $ZSH_VERSION == 4.<1->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is42(){
    [[ $ZSH_VERSION == 4.<2->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is425(){
    [[ $ZSH_VERSION == 4.2.<5->* || $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is43(){
    [[ $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is433(){
    [[ $ZSH_VERSION == 4.3.<3->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is439(){
    [[ $ZSH_VERSION == 4.3.<9->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

#f1# Checks whether or not you're running grml
isgrml(){
    [[ -f /etc/grml_version ]] && return 0
    return 1
}

#f1# Checks whether or not you're running a grml cd
isgrmlcd(){
    [[ -f /etc/grml_cd ]] && return 0
    return 1
}

if isgrml ; then
#f1# Checks whether or not you're running grml-small
    isgrmlsmall() {
        if [[ ${${${(f)"$(</etc/grml_version)"}%% *}##*-} == 'small' ]]; then
            return 0
        fi
        return 1
    }
else
    isgrmlsmall() { return 1 }
fi

isdarwin(){
    [[ $OSTYPE == darwin* ]] && return 0
    return 1
}

#f1# are we running within an utf environment?
isutfenv() {
    case "$LANG $CHARSET $LANGUAGE" in
        *utf*) return 0 ;;
        *UTF*) return 0 ;;
        *)     return 1 ;;
    esac
}

# check for user, if not running as root set $SUDO to sudo
(( EUID != 0 )) && SUDO='sudo' || SUDO=''

# change directory to home on first invocation of zsh
# important for rungetty -> autologin
# Thanks go to Bart Schaefer!
isgrml && checkhome() {
    if [[ -z "$ALREADY_DID_CD_HOME" ]] ; then
        export ALREADY_DID_CD_HOME=$HOME
        cd
    fi
}


# autoload wrapper - use this one instead of autoload directly
# We need to define this function as early as this, because autoloading
# 'is-at-least()' needs it.
function zrcautoload() {
    emulate -L zsh
    setopt extended_glob
    local fdir ffile
    local -i ffound

    ffile=$1
    (( found = 0 ))
    for fdir in ${fpath} ; do
        [[ -e ${fdir}/${ffile} ]] && (( ffound = 1 ))
    done

    (( ffound == 0 )) && return 1
    if [[ $ZSH_VERSION == 3.1.<6-> || $ZSH_VERSION == <4->* ]] ; then
        autoload -U ${ffile} || return 1
    else
        autoload ${ffile} || return 1
    fi
    return 0
}



# append history list to the history file; this is the default but we make sure
# because it's required for share_history.
setopt append_history


# import new commands from the history file also in other zsh-session
#is4 && setopt share_history

# save each command's beginning timestamp and the duration to the history file
setopt extended_history

# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
is4 && setopt histignorealldups

# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace



# display PID when suspending processes as well
setopt longlistjobs

# report the status of backgrounds jobs immediately
setopt notify


if [ `uname` = "FreeBSD" ]; then

    typeset -g -A key

    key[F1]='^[OP'
    key[F2]='^[OQ'
    key[F3]='^[OR'
    key[F4]='^[OS'
    key[F5]='^[[15~'
    key[F6]='^[[17~'
    key[F7]='^[[18~'
    key[F8]='^[[19~'
    key[F9]='^[[20~'
    key[F10]='^[[21~'
    key[F11]='^[[23~'
    key[F12]='^[[24~'
    key[Backspace]='^?'
    key[Insert]='^[[2~'
    key[Home]='^[[H'
    key[PageUp]='^[[5~'
    key[Delete]='^[[3~'
    key[End]='^[[F'
    key[PageDown]='^[[6~'
    key[Up]='^[[A'
    key[Left]='^[[D'
    key[Down]='^[[B'
    key[Right]='^[[C'
    key[Menu]='*'

    bindkey "${key[Home]}" beginning-of-line
    bindkey "${key[End]}" end-of-line
fi


# Load all files from .shell/zshrc.d directory
if [ -d $HOME/.zshrc.d ]; then
  for file in $HOME/.zshrc.d/*.zsh; do
    source $file
  done
fi


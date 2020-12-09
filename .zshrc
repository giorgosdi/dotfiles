# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/giorgos.dimitriou/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	zsh-autosuggestions
	history-substring-search
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


#### Bash completion ####
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# ZSH syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pyenv virtualenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


############ Custom functions ############
aws_prof() {
	export AWS_DEFAULT_PROFILE=$1
}


# Vault confugiration

 vault-config() {
    # The path to wherever you have cloned the 'manifests' repo
    export SHIPCAT_MANIFEST_DIR=$HOME/babylon/manifests

    # If you do not use pass, change the command to the correct one for your password manager
    export BABYLON_GITHUB_PAT="$(pass show git-token)"
 }

 vault-login() {
   VAULT_ADDR="$(yq -y ".regions | map(select(.name == \"$1\") .vault)" < ${SHIPCAT_MANIFEST_DIR}/shipcat.conf | yq '.[0].url' -r)"
   export VAULT_ADDR
   unset VAULT_TOKEN
   vault login -method=github token="${BABYLON_GITHUB_PAT}"
 }
vault-edit() {
   VAULT_ADDR="$(yq -y ".regions | map(select(.name == \"$1\") .vault)" < ${SHIPCAT_MANIFEST_DIR}/shipcat.conf | yq '.[0].url' -r)"
   echo "${BABYLON_GITHUB_PAT}" | pbcopy
   open "${VAULT_ADDR}/ui/vault/secrets/secret/list/$1/"
 }

 tf_params () {
   #pass terraform parameters
   export ACCOUNT="$1"
   export LOCATION="$2"
   export ENVIRONMENT="$3"
 }

 tf_init () {
  #run terraform init
  /usr/local/bin/terraform init -backend-config=environments/${ACCOUNT}/${LOCATION}/${ENVIRONMENT}/backend.tfvars
 }

 tf_plan () {
  #run terraform plan
  /usr/local/bin/terraform plan -var-file=environments/${ACCOUNT}/${LOCATION}/${ENVIRONMENT}/environment.tfvars
 }

 vault-okta-login() {
   unset VAULT_TOKEN
   unset VAULT_NAME
   unset VAULT_ADDR

   if [ -z $1 ]; then
     VAULT_NAME=$(yq -y ".regions[].vault.folder" ${SHIPCAT_MANIFEST_DIR}/shipcat.conf  | awk '{print $2}' | fzf +m)
     else
     VAULT_NAME=$1
   fi
   VAULT_ADDR=$(yq -y ".regions | map(select(.name == \"$VAULT_NAME\") .vault)" < ${SHIPCAT_MANIFEST_DIR}/shipcat.conf | yq '.[0].url' -r)
	echo $VAULT_ADDR
   if [[ $1 = "sandbox" ]]; then
     export VAULT_ADDR="https://vault.sandboxuk.babylontech.co.uk"
   elif [[ $1 = "staging-us" ]]; then
     export VAULT_ADDR="https://vault.us.staging.babylontech.co.uk"
   fi

   echo 'Name: '$VAULT_NAME
   echo 'Server: '$VAULT_ADDR
   export VAULT_ADDR

   vault login -method=okta username=giorgos.dimitriou

 }

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


#### Kubernetes ####

change-cluster() {
  echo 'Configuring Vault..'
  vault-config
  echo "Logging in Vault $1.."
  vault-okta-login $1
  echo "Changing to cluster $1"
  shipcat login -r $1
}

## Kubectl autocomplete ##
source <(kubectl completion zsh)

echo 'complete -F __start_kubectl k' >>~/.zshrc
## Krew ##

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

## Kubectl aliases ##

[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
function kubectl() { echo "+ kubectl $@">&2; command kubectl $@; }

function kalias() {
	if [ -z  $@ ]
	then
		cat ~/.kubectl_aliases
	else
		cat ~/.kubectl_aliases | cut -d ' ' -f 2- | grep "$@" --color=never
	fi
}


#### SSH ####
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add


#### Terraform ####
alias tf=/usr/local/bin/terraform


#### Admiral Podrington ####
# Use kubectl to connect to admiral-podrington
function podrington-console {
  kubectl config current-context | xargs -I % echo Connecting to %
  kubectl get pods -l=app=admiral-podrington | sed -n '2p' | cut -f1 -d$' ' | xargs -o -I % kubectl exec -it % -- /bin/bash
}


#### Configure hub cli ####
hub-config() {
 unset GITHUB_TOKEN

 export GITHUB_TOKEN="$(pass show git-token)"
} 


#### Golang ####
export GOPATH=$HOME/go
complete -F __start_kubectl k
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"


#### PROMTP ####
prompt_k8s() {
  local ctx
  if ctx=$(kubectl config current-context 2> /dev/null); then
    echo -e " (${blue}${ctx}${white})"
  fi
}

PS1+="$(prompt_k8s)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/giorgos.dimitriou/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/giorgos.dimitriou/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/giorgos.dimitriou/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/giorgos.dimitriou/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
complete -F __start_kubectl k

connect_me () {
  echo "Connecting to $SERVER"
  echo "URL: $URL"
  export VAULT_ADDR=https://localhost:4443
  export VAULT_SKIP_VERIFY=true
  ps aux | grep ssh | grep 4443 | awk '{print $2}' | xargs kill -9
  INSTANCE=$(aws ec2 --region $REGION describe-instances --filters "Name=tag:Name,Values=bastion-$BASTION" --query 'Reservations[*].Instances[*].{Name:Tags[?Key==`Name`]|[0].Value,Instance:InstanceId}' --output text | grep "i-" | awk '{print $1}')
  ssh -f -N -L 4443:${URL}:443 $(whoami)-admin@${INSTANCE}.${REGION}
  if [[ $SERVER == "prod-uk" ]] || [[ $SERVER == "prod-us" ]] || [[ $SERVER == "prod-sg" ]]; then
    vault login -method=okta username=$(whoami)
  else
    vault login -method=github token="${BABYLON_GITHUB_PAT}"
  fi
}

env-login () {
  eval "$('aws-okta' env ${1})"
}

vault-prod-login() {
  unset VAULT_TOKEN
  unset VAULT_NAME
  unset VAULT_ADDR

if [[ $1 = "prod-uk" ]]; then
    env-login babylonhealth-production-admin
    URL="vault-uk.babylonpartners.com"
    REGION="eu-west-2"
    SERVER="prod-uk"
    BASTION="uk-prod"
    connect_me
  elif [[ $1 = "prod-us" ]]; then
    env-login babylonhealth-production-us-east-1-admin
    URL="vault.us.babylonpartners.com"
    REGION="us-east-1"
    SERVER="prod-us"
    BASTION="us-prod"
    connect_me
  elif [[ $1 = "prod-sg" ]]; then
    env-login babylonhealth-production-admin
    URL="vault.sg.babylonpartners.com"
    REGION="ap-southeast-1"
    SERVER="prod-sg"
    BASTION="sg-prod"
    connect_me
  elif [[ $1 = "prod-global1" ]]; then
    env-login babylonhealth-production-admin
    URL="vault.global1.babylonpartners.com"
    REGION="eu-west-1"
    SERVER="prod-global1"
    BASTION="global1-prod"
    connect_me
  elif [[ $1 = "prod-ca" ]]; then
    env-login telus-prod-admin
    URL="vault.babylonbytelushealth.com"
    REGION="ca-central-1"
    SERVER="prod-ca"
    BASTION="ca-prod"
    connect_me
  elif [[ $1 = "dev-uk" ]]; then
    env-login babylonhealth-development-admin
    URL="vault.babylontech.co.uk"
    REGION="eu-west-2"
    SERVER="dev-uk"
    BASTION="uk-dev"
    connect_me
else
    echo "please specify env (e.g. prod-uk, prod-us, prod-sg)"
  fi

}
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k
complete -F __start_kubectl k

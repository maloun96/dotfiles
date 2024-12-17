 # Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reload="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/usr/local/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias dotfiles="cd $DOTFILES"
alias aliases="vi $DOTFILES/aliases.zsh"
alias paths="vi $DOTFILES/path.zsh"
alias vars="vi $DOTFILES/variables.zsh"
alias qq="clear"

alias quickclean='echo "🧹 Starting Mac maintenance..." && \
    echo "\n📊 Memory status before cleanup:" && \
    top -l 1 | grep PhysMem && \
    echo "\n🗑️  Purging memory..." && \
    sudo purge && \
    echo "\n🧽 Clearing user caches..." && \
    rm -rf ~/Library/Caches/* && \
    echo "\n🌐 Flushing DNS cache..." && \
    sudo dscacheutil -flushcache && \
    sudo killall -HUP mDNSResponder && \
    echo "\n🗂️  Clearing application caches..." && \
    rm -rf ~/Library/Caches/Google/Chrome/Default/Cache/* && \
    rm -rf ~/Library/Caches/com.apple.Safari/WebKitCache/* && \
    echo "\n📦 Clearing derived data..." && \
    rm -rf ~/Library/Developer/Xcode/DerivedData/* && \
    echo "\n🗑️  Clearing trash..." && \
    rm -rf ~/.Trash/* && \
    echo "\n📊 Memory status after cleanup:" && \
    top -l 1 | grep PhysMem && \
    echo "\n✨ Maintenance complete! Your Mac should feel faster now."'

alias kpstorm='echo "🔪 Killing PhpStorm processes..." && \
    pkill -9 -f "PhpStorm" && \
    echo "✨ PhpStorm processes terminated."'

# Directories
alias www="cd /Users/victormalai/www"
alias pbx="cd /Users/victormalai/www/pbx && pstorm . && cd frontend && npm run dev"
alias roombriks="cd /Users/victormalai/www/roombricks && pstorm . && npm run dev"
alias dots="cd $DOTFILES"
alias library="cd $HOME/Library"
alias sites="cd $HOME/Sites"

# Laravel
alias a="php artisan"
alias ams="php artisan migrate:fresh --seed"
alias tests="php artisan test"
alias migrate="php artisan migrate"
alias rollback="php artisan migrate:rollback"
alias r_m="rollback && migrate"
alias log="rm -rf ./storage/logs/laravel.log && touch ./storage/logs/laravel.log && tail -f ./storage/logs/laravel.log"
alias sail='bash vendor/bin/sail'
alias larastan="vendor/bin/phpstan analyse"
alias d="php artisan dusk"
alias fresh="composer fresh"
alias t="composer test"
alias tt="php artisan test --parallel"

# PHP
alias php74="/usr/local/Cellar/php@7.4/7.4.13/bin/php"
alias php72="/usr/local/Cellar/php@7.2/7.2.26/bin/php"
alias cfresh="rm -rf vendor/ composer.lock && composer i"
alias watch="phpunit-watcher"
alias w="phpunit-watcher watch --filter="
alias cr="composer require"
alias cup="composer update"
alias p='./vendor/bin/phpunit'
alias pp="php artisan test --parallel"

alias pest="./vendor/bin/pest"
alias pw="./vendor/bin/pest --watch"
alias usephp81="brew unlink php && brew link --overwrite --force php@8.1 && valet use php@8.1 --force && valet restart"
alias usephp82="brew unlink php && brew link --overwrite --force php@8.2 && valet use php@8.2 --force && valet restart"
alias usephp8="brew unlink php && brew link --overwrite php@8.0 && valet use php@8.0 --force"
alias usephp74="brew unlink php && brew link --overwrite php@7.4 && valet use php@7.4 --force"
alias usephp73="brew unlink php && brew link --overwrite php@7.3 && valet use php@7.3 --force"
alias brew:up='brew update && brew upgrade && brew cleanup'

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias m="mocha -r esm --watch"
alias mm="mocha -r esm --watch -g "

# Vagrant
alias v="vagrant global-status"
alias vup="vagrant up"
alias vhalt="vagrant halt"
alias vssh="vagrant ssh"
alias vreload="vagrant reload"
alias vpreload="vagrant reload --provision"
alias vrebuild="vagrant destroy --force && vagrant up"

# Docker
alias docker-composer="docker-compose"
#alias dstop="docker stop $(docker ps -a -q)"
#alias dpurgecontainers="dstop && docker rm $(docker ps -a -q)"
#alias dpurgeimages="docker rmi $(docker images -q)"
#dbuild() { docker build -t=$1 .; }
#dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }

# Git
alias nah='git reset --hard HEAD; git clean -df'
alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"
alias pwip="push wip"
alias ss="git status"
alias gcn="git checkout -b"
alias gcm="git checkout master && git pull origin master"
alias gc4x="git checkout 4.x && git pull origin 4.x" # Restify
alias gc5x="git checkout 5.x && git pull origin 5.x" # Restify
alias gc6x="git checkout 6.x && git pull origin 6.x" # Restify
alias gc7x="git checkout 7.x && git pull origin 7.x" # Restify
alias gc8x="git checkout 8.x && git pull origin 8.x" # Restify
alias gplmm="git pull origin main"
alias gcmm="git checkout main && git pull origin main"
alias gcs="git checkout staging && git pull origin staging"
alias gpls="git pull origin staging"
alias gpld="git pull origin development"
alias gps="git pull origin staging"
alias gplm="git pull origin master"
alias gcd="git checkout development && git pull origin development"
alias gph="git push origin HEAD"
alias gplh="git pull origin HEAD"
alias gcdd="git checkout develop && git pull origin develop"
alias gfa="git fetch --all"
alias prd="gh pr create -B development -f"
alias prdd="gh pr create -B develop -f"
alias prs="gh pr create -B staging"
alias prm="gh pr create -B master -f"
alias prmm="gh pr create -B main --fill"
alias gtrigger="git commit --allow-empty -m 'wakey wakey GitHub Actions'"
alias glog="git --no-pager log --all --color=always --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' | less -r -X +/[^/]HEAD"

alias gfeat='f() { git commit -m "feat($1): $2" "${@:3}"; }; f'
alias gfix='f() { git commit -m "fix($1): $2" "${@:3}"; }; f'
alias gdocs='f() { git commit -m "docs($1): $2" "${@:3}"; }; f'
alias gstyle='f() { git commit -m "style($1): $2" "${@:3}"; }; f'
alias grefactor='f() { git commit -m "refactor($1): $2" "${@:3}"; }; f'
alias gperf='f() { git commit -m "perf($1): $2" "${@:3}"; }; f'
alias gtest='f() { git commit -m "test($1): $2" "${@:3}"; }; f'
alias gchore='f() { git commit -m "chore($1): $2" "${@:3}"; }; f'
alias gbuild='f() { git commit -m "build($1): $2" "${@:3}"; }; f'
alias gci='f() { git commit -m "ci($1): $2" "${@:3}"; }; f'


alias about="neofetch"
alias vi="vim"
alias search="grep -rnw . -e $1"

# Redis
alias start-redis="brew services start redis"

# Composer

# Port
alias killme="lsof -n -i4TCP:"
alias killpid="sudo kill -9 $0"
alias who="sudo lsof -i :80"
alias nstop="sudo brew services stop nginx"
alias nstart="sudo brew services start nginx"
alias nrestart="sudo nginx -s reload && sudo apachectl restart && valet restart"
alias astop="sudo apachectl stop"
alias astart="sudo apachectl start"
alias cleardns="sudo killall -HUP mDNSResponder"


# ARM
alias mbrew="arch -x86_64 brew"

# Python
alias pip="pip3"

# Mongo
alias mongo-start="brew services start mongodb-community"
alias mongo-stop="brew services stop mongodb-community"

## Restify

alias repo="a restify:repository $1"

## MySQL
alias mysql.start="cd /Users/eduardlupacescu/Sites/work/mysql-docker && docker-compose up -d"
alias mysql.stop="cd /Users/eduardlupacescu/Sites/work/mysql-docker && docker-compose down"

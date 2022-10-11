# ref: https://bitbucket.org/durdn/cfg/src/master/.bin/install.sh
REPO=https://github.com/peg7/dotfiles.git

## change dir to home dir.
cd ~

## clone this repo as bare repo.
git clone --bare ${REPO} ${HOME}/.dotfiles

## set alias to work with this repo.
function dotctl {
   /usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} $@
}

## make backup dir
mkdir -p .dotfiles-backup

## try checkout
dotctl checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
else
  ## if checkout is failed, move duplicated files to backup dir.
  echo "Backing up pre-existing dotfiles.";
  dotctl checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;

## retry checkout
dotctl checkout

## add config
dotctl config status.showUntrackedFiles no

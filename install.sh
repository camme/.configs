/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install zsh
brew install neovim
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
brew install python
brew install python3
brew install cmake
brew install the_silver_searcher
brew install reattach-to-user-namespace
pip2 install neovim --upgrade
pip3 install neovim --upgrade
mkdir -p ~/.vim/tmp
mkdir -p ~/.vim/backup

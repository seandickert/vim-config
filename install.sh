#!/bin/sh


home_dir=/Users/seandickert/.vim/
vim_config_loc=/Users/seandickert/workspace/vim-config/
ln -sfn "${vim_config_loc}/vimrc" "${home_dir}/vimrc"
ln -sfn "${vim_config_loc}/autoload" "${home_dir}/autoload"
ln -sfn "${vim_config_loc}/bundle" "${home_dir}/bundle"
# these are library names we wish to install
# and we'll do so
install_bundles=(
	dwm.vim-master
	syntastic-master
	SimpylFold-master
	indentpython.vim-master
	taglist.vim-master
	vim-closetag-master
	nerdcommenter-master
	delimitMate-master
	vim-fugitive-master
	indentLine-master
	vim-trailing-whitespace-master
	nerdtree-master
	vim-airline-master
	ctrlp.vim-master
)

for i in ${!install_bundles[@]}; do
 	ln -sfn "${vim_config_loc}/libs/${install_bundles[$i]}" "${vim_config_loc}/bundle/${install_bundles[$i]}"
done

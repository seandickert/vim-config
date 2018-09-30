# vim-config
Everything vim.  Included in the repository are a number of useful plugins (contained in the ./lib directory)
To use this repository, create a .vim directory under your home directory e.g. /home/sean/.vim and create a bundle directory within the .vim directory

Symlink the vimrc file in the repo to /home/sean/.vim/vimrc.  Similarly, symlink the autoload directory under the .vim directory.

To include any of the libraries in the libs directory, include a symlink under the bundle directory to the library in the libs directory.

With the repo checked out under /home/sean/development/vim-config, the top of the .vim folder under /home/sean/.vim should be structured as:
```
/home/sean/.vim/vimrc -> /home/sean/development/vim-config/vimrc
/home/sean/.vim/autoload -> /home/sean/development/vim-config/autoload
/home/sean/.vim/bundle
```

To include the plugins, for example ctrlp, symlink as so:
```
/home/sean/.vim/bundle/ctrlp -> /home/sean/development/vim-config/libs/ctrlp.vim-master
```

$MYVIMRC should be set to the location of the vimrc file e.g. /home/sean/.vim/vimrc

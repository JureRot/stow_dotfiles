# dotfiles backup and management system using GNU stow

### Description:

[Stow utility](https://www.gnu.org/software/stow/) is used to manage and sync files by creating symlinks to a single origin directory in home directory.  
This is achieved by creating a specific file structure from which stow know how to recreate all the symlinks.  
This enables us to have all the dotfiles in one place which we can backup using version control and have stow recreate all the symlinks all over our system.


### Instruction:

For example to stow a file (for a specific topic) that is normally in `~/.config/folder/file.txt` you would create the following file structure in your home directory `~/stow_dir/topic/.config/folder/file.txt`  
Then using `stow topic` command in `~/stow_dir` a symlink to the `~/stow_dir/topic/.config/folder/` will be created in `~/.config/folder`.  
(When running the stow command, if the location where symlink should be created already contains the file name (in other words there is a conflict) you can add --adopt flag to move them first to stow_dir and than create symlinks. Note this might override some changes if not backed up.)  
Editing either file (the one in stow_dir or the symlink) will change both of them.

So in this case all you need to do is version control the stow_dir and all you dotfiles will be backedup and in case you need to replace them you can just clone the entire stow_dir and call stow command for each of them.

Changing and maintaining them is also easy since editing the symlink will edit the original file in sto_dir. All you need to do is to commit the changes in stow_dir to be backed up.

### Content:
- tmux
- kanata
- hypr
- waybar
- bash (.bashrc, .bash_profile)
- nvim (package directories are ignored in git)
- kitty terminal

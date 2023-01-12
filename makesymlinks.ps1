
# run this script in this folder to link the appropriate places in vm
# link directory
New-Item -ItemType Junction -Path "~\.vim" -Target ".vim"
New-Item -ItemType Junction -Path "~\AppData\Local\nvim" -Target ".\.config\nvim\"

# link file
New-Item -ItemType SymbolicLink -Path "~\.vimrc" -Target ".\.vimrc"


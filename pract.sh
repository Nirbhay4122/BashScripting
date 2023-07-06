#!/bin/bash

RUN_COMMAND() { $1 | sed "s/^/[INFO]  /"; }
PKG_INSTALL() { apt-get install $1 -y; }
pkgs=('curl' 'wget' 'python3' 'sed' 'grep')
# RUN_COMMAND "echo Installing basic dependencies."
for pkg in ${pkgs[@]}; do RUN_COMMAND "PKG_INSTALL ${pkg}"; done



# To get extracted dir
#!/bin/bash

# Extract the tar file
tar -xf file1.tar

# Find the directory name
dir_name=$(tar -tf file1.tar | head -n 1 | sed -e 's@/.*@@')

# Run 'cd' command to the new directory
cd "$dir_name"

# Do whatever you need to do in the new directory

# Rest of your script...

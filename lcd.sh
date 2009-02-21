# Copyright (c) 2008 Dean McNamee <dean@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# lcd - lazy change directory.  key => directory shortcut mappings.
#
# Add this to your bash .profile, it will define the following aliases:
#  - acd <key>: Add a mapping from the current directory to the key |key|.
#  - lcd <key>: Jump to the directory mapped with the key |key|.
#  - pcd: Print all key / directory mappings.
#  - dcd <key>: Delete a mapping.
#
# The mappings are stored in ~/.lcdrc.  This file will initially be created
# when you use the acd command.  lcd's biggest feature is it's simplicity, it
# is implemented in a few lines of bash, reusing existing fast tools.  The
# mapping file is very simple, easy to share / merge between machines, etc.
#
# Example usage:
#   $ cd /some/really/long/path/that/is/annoying/to/type
#   $ acd long  # Create a mapping from current directory to the key "long".
#   $ cd  # Change back to your home directory, or somewhere else.
#   $ pcd long  # Change to the really long annoying path.

acd() {
  if [ -z "$1" ]; then
    echo "Map the current directory to dirkey.  Will overwrite a previous key."
    echo "usage: acd dirkey"
    return
  fi
  dcd "$1"  # Make sure any old keys are deleted
  echo "$1,$PWD" >> ~/.lcdrc
  echo "$1 -> $PWD"
}
lcd() {
  if [ -z "$1" ]; then
    echo "List all of the directory / dirkey mappings."
    echo "usage: lcd dirkey"
    return
  fi
  THEDIR=`grep -m 1 "^$1," ~/.lcdrc | cut -d, -f 2-`
  if [ -z "$THEDIR" ]; then
    echo "lcd: \"$1\" is not a known directory key."
  else
    cd "$THEDIR"
  fi
}
pcd() {
  sed 's/,/\n  /' ~/.lcdrc
}
dcd() {
  if [ -z "$1" ]; then
    echo "Delete the directory mapping for dirkey."
    echo "usage: dcd dirkey"
    return
  fi
  sed -i "/^$1,/ d" ~/.lcdrc
}

_compute_lcd_completion() {
  COMPREPLY=( $( grep "^$2" ~/.lcdrc | cut -d, -f 1 ) )
}
complete -F _compute_lcd_completion lcd dcd

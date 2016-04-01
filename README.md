# stubproj

*Goal: Sit down and open a terminal, type one command, and be looking at a remote Jupyter Notebook server.*

Some bash kludges to simplify repetitive ssh / activate environment / cd for a bunch of different project-specific environments.

As with most things built naively around Jupyter, this is pretty insecure. Use it within a firewall/VPN, not over the Internet. (It makes you set a password, but there's no session expiry and no SSL/TLS.)

## Installation

### On any remote hosts (servers) that you work with regularly

  * Clone this repository somewhere.
  * Ensure `conda` is installed and available on the $PATH
  * Add a line to your `.bashrc`:
  
      source /path/to/this/repo/bin/remote-aliases.sh
  * Add a symbolic link to `stubproj` somewhere on your $PATH
  
      ln -s /path/to/this/repo/bin/stubproj ~/bin/stubproj

### On your own (local) machine

  * Clone this repository somewhere.
  * Add a line to your `.bashrc`:
  
      source /path/to/this/repo/bin/local-aliases.sh

## Usage

### Create a new project

    stubproj PROJ_DIR PROJ_NAME PORT

Example creating a project `newproj` rooted at `/grp/jwst/myfolder` and with a notebook server on port 9900. 

    local$ ssh myfavoritehost
    myfavoritehost$ stubproj /grp/jwst/myfolder newproj 9900

Follow the instructions provided to configure a password and add `newproj` to your `~/.stubproj_list` on your **local** machine:

    local$ echo "newproj myfavoritehost 9900" >> ~/.stubproj_list

### Working on `newproj` from a local terminal

Start a new remote terminal in the `newproj` project with:

    local$ proj newproj
    (newproj)myfavoritehost$

Open the remote notebook server for `newproj`:

    local$ projnb newproj
    discarding /home/you/miniconda3/bin from PATH
    prepending /home/you/miniconda3/envs/newproj/bin to PATH
    Notebook for newproj already started as PID 129450
    (newproj)myfavoritehost$ 

(If there isn't a notebook server running, one will be started.)

If you want to stop the notebook server:

    local$ projnboff newproj

### Working on `newproj` from `myfavoritehost`

Activate the `newproj` environment and change to the working directory:

    myfavoritehost$ localproj newproj
    (newproj)myfavoritehost$

Start the notebook server without opening a browser window:

    myfavoritehost$ localprojnb
    discarding /home/me/miniconda3/bin from PATH
    prepending /home/me/miniconda3/envs/newproj/bin to PATH
    Started notebook for newproj (pid: 3555)
    myfavoritehost$

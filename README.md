# stubproj

*Goal: Sit down and open a terminal, type one command, and be looking at a remote Jupyter Notebook server.*

Some bash kludges to simplify repetitive ssh / activate environment / cd for a bunch of different project-specific environments.

As with most things built naively around Jupyter, this is pretty insecure. Use it within a firewall/VPN, not over the Internet. (It makes you set a password, but there's no session expiry and no SSL/TLS.)

## Installation

### On your own (local) machine

  * Clone this repository into ~/.stubproj
  
      git clone https://github.com/josePhoenix/stubproj.git ~/.stubproj

  * Add a line to your `.bashrc`:
  
      echo "source ~/.stubproj/bin/local-aliases.sh" >> ~/.bashrc

### On any remote hosts (servers) that you work with regularly

Stubproj depends on `conda` to install packages and keep project environments separate. So, make sure `conda` is available on your remote server when you open a shell via ssh. Stubproj also assumes you're on Linux (for `/proc`)

    $ ssh myfavoritehost
    $ which conda
    /user/jlong/miniconda3/bin/conda

Next, clone this repository into `~/.stubproj` on the *remote* host

    $ git clone https://github.com/josePhoenix/stubproj.git ~/.stubproj

Add a line sourcing the *remote* aliases to your `.bashrc`:
  
    echo "source ~/.stubproj/bin/remote-aliases.sh" >> ~/.bashrc

## Usage

### Create a new project

    stubproj PROJ_NAME PROJ_HOST PROJ_DIR PROJ_PORT

Example creating a project `newproj` on `myfavoritehost` rooted at `/grp/jwst/myfolder` and with a notebook server on port 9900.

    local$ stubproj newproj myserver /grp/jwst/myfolder 9900

Follow the instructions provided to configure a password and add `newproj` to your `~/.stubproj_list` on your **local** machine:

    local$ echo "newproj myserver /grp/jwst/myfolder 9900" >> ~/.stubproj/projects

### Create a new project with a different set of default packages

Stubproj will check if a `conda` env already exists, and install the packages it needs into that. This means you can set up the environment yourself.

For example, the LSST stack is [available as conda packages](https://pipelines.lsst.io/install/conda.html), but currently stuck on Python 2 (Fall 2016). Make an `lsst` environment:

    myfavoritehost$ conda config --add channels http://conda.lsst.codes/stack
    myfavoritehost$ conda create --name lsst python=2 lsst-distrib lsst-sims

Create a project skeleton with the same name:

    local$ stubproj lsst myfavoritehost /astro/lsst 9901

Add some customizations for the LSST Stack:

    local$ proj lsst
    (lsst)myremotehost$ mkdir -p "$CONDA_PREFIX/etc/conda/activate.d"
    (lsst)myremotehost$ echo "source eups-setups.sh" >> "$CONDA_PREFIX/etc/conda/activate.d/load_eups.sh"
    (lsst)myremotehost$ echo "setup meas_deblender" >> "$CONDA_PREFIX/etc/conda/activate.d/load_eups.sh"

Now when you run `proj lsst` or `projnb lsst`, you'll get an environment with the LSST Stack installed and their `meas_deblender` package available.

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

### Deleting `newproj`

Save all your work and copy it into a different project (if you want).

Shut down the notebook server:

    local$ projnboff newproj
    Doing command: localprojnboff newproj on host: 10.0.0.1
    Stopped notebook for newproj
    Connection to 130.167.200.6 closed.

To delete `newproj`, edit `~/.stubproj/projects` on both your local machine and `myfavoritehost` to remove the corresponding line.

To destroy the files, remove the environment and `rm` the folder from `myfavoritehost`:

    myfavoritehost$ conda env remove -n newproj --yes
    myfavoritehost$ rm -r /grp/jwst/myfolder

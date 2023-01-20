# usv_ws Supermodule Instructions

usv_ws is a git repo that includes several other (4 so far) repos as git submodules. 

For details about git submodules see https://git-scm.com/book/en/v2/Git-Tools-Submodules

## Summary:

```
foo@bar:~$ git clone --recurse-submodules git@github.com:platypusllc/usv_ws/
foo@bar:~$ cd usv_ws/
foo@bar:~/usv_ws$ docker build -t usv .
foo@bar:~/usv_ws$ docker run -it --mount type=bind,source="$(pwd)",target=/ws usv
root@52414428f42f:/ws# 
root@52414428f42f:/ws# colcon build
root@52414428f42f:/ws# source install/setup.bash 
root@52414428f42f:/ws# ros2 launch autonomy_sim_bringup autonomy_sim.launch.py
```
Note:  There are several simple shell scripts in the usv_ws repo that I added to simplify some things.

They were written and used under linux. They should work under Mac OSX. Under Windows, I'm afraid you're on your own.

With a git submodule, if you do "git status" or similar commands, the command does not recurse into the submodules. These scripts cd into each of the four submodules and run the command, so you can quickly and easily see changes over all of the submodules.  Note, they do not at this time run the git command at the top, in usv_ws itself.

- ./git_status.sh
- ./git_branches.sh
- ./git_pull.sh
- ./git_current.sh

Also:

- ./run_docker.sh, runs the docker instance with the paramaters recommended above.
- ./launch_ros.sh, to be run from inside the docker instance, starts ROS with the parameters recommended above.


## Steps To Clone, Build and Run the usv_ws ROS Node

1. Git clone the usv_ws repo.

The --recurse-submodules parameter will also init and update the submodule directories under usv_ws/src

Without the --recurse-submodules argument, the subdirectories under usv_ws/src/ will remain empty.

```
foo@bar:~$ git clone --recurse-submodules https://github.com/platypusllc/usv_ws/
```

If you are new to GitHub, you may need to setup your ssh-key since this is a private repo, follow the instructions here: https://kbroman.org/github_tutorial/pages/first_time.html

2. Check out a branch in any submodule that you want to make changes to.

Submodules are **always** cloned with a detached head. This shouldn't matter for running the submodule, but if you make any changes to the code without first doing "git checkout branchname" then you have to sort out the detached head.  So for now, just go in and checkout to a branch for any submodule repo that you plan to make changes on.

For example, if you're planning on editing files in the simusv repo submodule:

```
foo@bar:~$ cd usv_ws/src/simusv
foo@bar:~/usv_ws/src/simusv$ git checkout main
foo@bar:~/usv_ws/src/simusv$ cd ../..
foo@bar:~/usv_ws$ 
```

3. Build the docker image with "docker build":

Note: Docker saves images elsewhere, outside of the git repo, so
subsequent invocations of "docker build" will use the already existing
images. There'll be a lot less output if you run "docker build" a
second time, even if you're doing it with a fresh git clone.

```
foo@bar:~/usv_ws$ docker build -t usv .
```

4. Run the docker image.

The "docker run" command below will:

- run the docker image
- mount the current working directory on your laptop as a volume inside docker
- under /ws in the docker container instance
- log you into the root shell on the docker container instance

Any changes you edit in the usv_ws repo on your laptop will be visible
in /ws.  You can edit files on your local machine and then run them
from inside the docker container instance.  Note: See the note about
"colcon build", below, about running changed code.

However, going in the opposite direction doesn't work as well.  In
particular, attempting to use the git commands on a repo from within
the docker image will not work, and you'll see a warning about:



> fatal: detected dubious ownership in repository [...etc...]

To run the docker image:

```
foo@bar:~/usv_ws$ docker run -it --mount type=bind,source="$(pwd)",target=/ws usv
root@52414428f42f:/ws# 
```

Note: While docker container instances are persistent, "docker run" starts a new instance each time.  To start previous a container instance you can use "docker start" but general practice in the docker world is to start a new container instance every time.  You should use tools (starting with a Dockerfile) to script any necessary changes, rather than relying on manually making changes inside a running container instance.

5. Source the install/setup.bash file to set up environment variables.

```
root@52414428f42f:/ws# source install/setup.bash 
root@52414428f42f:/ws#
```

6. Build the ROS node inside the docker image:

The "target=/ws" parameter should have started you inside /ws in the docker container instance. If you're not in /ws, cd into /ws.

Note: Also, if you edit the code, you'll need to re-run "colcon build" before restarting the ROS node, to run the changed code.

```
root@52414428f42f:/ws# colcon build
Starting >>> autonomy_interfaces
Starting >>> simusv
--- stderr: simusv                                                                  
/usr/lib/python3/dist-packages/setuptools/command/install.py:34: SetuptoolsDeprecationWarning: setup.py install is deprecated. Use build and pip and other standards-based tools.
  warnings.warn(
---
Finished <<< simusv [1.20s]
Finished <<< autonomy_interfaces [7.84s]                     
Starting >>> autonomy
--- stderr: autonomy                   
/usr/lib/python3/dist-packages/setuptools/command/install.py:34: SetuptoolsDeprecationWarning: setup.py install is deprecated. Use build and pip and other standards-based tools.
  warnings.warn(
---
Finished <<< autonomy [1.07s]
Starting >>> autonomy_sim_bringup
Finished <<< autonomy_sim_bringup [0.95s]                   

Summary: 4 packages finished [10.1s]
  2 packages had stderr output: autonomy simusv
root@52414428f42f:/ws#
```

7. Launch the ROS nodes.

Note, currently the sim runs for 100 loops and then exits.  That was
for testing purposes. Obviously we should change this soon.

```
root@52414428f42f:/ws# ros2 launch autonomy_sim_bringup autonomy_sim.launch.py
```

## Log of Cloning, Running, Building and Launching

For illustrative purposes, here's a full log of going through the
process, on an Ubuntu 20.04 LTS install.

```
foo@bar:~$ git clone --recurse-submodules git@github.com:platypusllc/usv_ws/
Cloning into 'usv_ws'...
remote: Enumerating objects: 13, done.
remote: Counting objects: 100% (13/13), done.
remote: Compressing objects: 100% (11/11), done.
remote: Total 13 (delta 4), reused 11 (delta 2), pack-reused 0
Receiving objects: 100% (13/13), done.
Resolving deltas: 100% (4/4), done.
Submodule 'src/autonomy' (git@github.com:platypusllc/autonomy.git) registered for path 'src/autonomy'
Submodule 'src/autonomy_interfaces' (git@github.com:platypusllc/autonomy_interfaces.git) registered for path 'src/autonomy_interfaces'
Submodule 'src/autonomy_sim_bringup' (git@github.com:platypusllc/autonomy_sim_bringup.git) registered for path 'src/autonomy_sim_bringup'
Submodule 'src/simusv' (git@github.com:platypusllc/simusv.git) registered for path 'src/simusv'
Cloning into '/home/foo/usv_ws/src/autonomy'...
remote: Enumerating objects: 27, done.        
remote: Counting objects: 100% (27/27), done.        
remote: Compressing objects: 100% (18/18), done.        
remote: Total 27 (delta 9), reused 25 (delta 7), pack-reused 0        
Receiving objects: 100% (27/27), 7.59 KiB | 3.79 MiB/s, done.
Resolving deltas: 100% (9/9), done.
Cloning into '/home/foo/usv_ws/src/autonomy_interfaces'...
remote: Enumerating objects: 14, done.        
remote: Counting objects: 100% (14/14), done.        
remote: Compressing objects: 100% (12/12), done.        
remote: Total 14 (delta 2), reused 14 (delta 2), pack-reused 0        
Receiving objects: 100% (14/14), done.
Resolving deltas: 100% (2/2), done.
Cloning into '/home/foo/usv_ws/src/autonomy_sim_bringup'...
remote: Enumerating objects: 15, done.        
remote: Counting objects: 100% (15/15), done.        
remote: Compressing objects: 100% (11/11), done.        
remote: Total 15 (delta 4), reused 14 (delta 3), pack-reused 0        
Receiving objects: 100% (15/15), done.
Resolving deltas: 100% (4/4), done.
Cloning into '/home/foo/usv_ws/src/simusv'...
remote: Enumerating objects: 279, done.        
remote: Counting objects: 100% (279/279), done.        
remote: Compressing objects: 100% (179/179), done.        
remote: Total 279 (delta 164), reused 205 (delta 95), pack-reused 0        
Receiving objects: 100% (279/279), 75.11 KiB | 2.21 MiB/s, done.
Resolving deltas: 100% (164/164), done.
Submodule path 'src/autonomy': checked out '98edf7ae99af97f05d4bf4fd7c11cfe8a583e3cb'
Submodule path 'src/autonomy_interfaces': checked out '90980c72097c3c14fc141f12bdf8ea710a831788'
Submodule path 'src/autonomy_sim_bringup': checked out '2de9bb34c1fffa434be86065933dfe223b4c3048'
Submodule path 'src/simusv': checked out 'eff5bc5d0e640cef78c7e4407db148cf532dd81e'
foo@bar:~$ cd usv_ws/
foo@bar:~/usv_ws$ cd src/simusv/
foo@bar:~/usv_ws/src/simusv$ git branch -a
* (HEAD detached at eff5bc5)
  main
  remotes/origin/HEAD -> origin/main
  remotes/origin/main
foo@bar:~/usv_ws/src/simusv$ git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
foo@bar:~/usv_ws/src/simusv$ cd ..
foo@bar:~/usv_ws/src$ cd ..
foo@bar:~/usv_ws$ git branch -a
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/master
foo@bar:~/usv_ws$ cd
foo@bar:~$ cd usv_ws
foo@bar:~/usv_ws$ docker build -t usv .
Sending build context to Docker daemon  476.7kB
Step 1/6 : FROM ros:humble
 ---> c144c1e970a3
Step 2/6 : WORKDIR /temp
 ---> Running in 669bbcdb2af4
Removing intermediate container 669bbcdb2af4
 ---> e45fbf445fa7
Step 3/6 : RUN apt-get update && apt-get install -y ros-humble-mavros ros-humble-mavros-extras python3-pip
 ---> Running in 93687ab076e5
Get:1 http://archive.ubuntu.com/ubuntu jammy InRelease [270 kB]
Get:2 http://security.ubuntu.com/ubuntu jammy-security InRelease [110 kB]
Get:3 http://packages.ros.org/ros2/ubuntu jammy InRelease [4673 B]
Get:4 http://packages.ros.org/ros2/ubuntu jammy/main amd64 Packages [764 kB]
Get:5 http://security.ubuntu.com/ubuntu jammy-security/main amd64 Packages [616 kB]
Get:6 http://archive.ubuntu.com/ubuntu jammy-updates InRelease [114 kB]
Get:7 http://archive.ubuntu.com/ubuntu jammy-backports InRelease [99.8 kB]
Get:8 http://archive.ubuntu.com/ubuntu jammy/multiverse amd64 Packages [266 kB]
Get:9 http://archive.ubuntu.com/ubuntu jammy/universe amd64 Packages [17.5 MB]
Get:10 http://security.ubuntu.com/ubuntu jammy-security/restricted amd64 Packages [522 kB]
Get:11 http://security.ubuntu.com/ubuntu jammy-security/multiverse amd64 Packages [4642 B]
Get:12 http://security.ubuntu.com/ubuntu jammy-security/universe amd64 Packages [767 kB]
Get:13 http://archive.ubuntu.com/ubuntu jammy/main amd64 Packages [1792 kB]
Get:14 http://archive.ubuntu.com/ubuntu jammy/restricted amd64 Packages [164 kB]
Get:15 http://archive.ubuntu.com/ubuntu jammy-updates/universe amd64 Packages [955 kB]
Get:16 http://archive.ubuntu.com/ubuntu jammy-updates/restricted amd64 Packages [573 kB]
Get:17 http://archive.ubuntu.com/ubuntu jammy-updates/multiverse amd64 Packages [8056 B]
Get:18 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 Packages [918 kB]
Get:19 http://archive.ubuntu.com/ubuntu jammy-backports/universe amd64 Packages [7275 B]
Get:20 http://archive.ubuntu.com/ubuntu jammy-backports/main amd64 Packages [3175 B]
Fetched 25.4 MB in 12s (2063 kB/s)
Reading package lists...
W: http://packages.ros.org/ros2/ubuntu/dists/jammy/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.
Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  geographiclib-tools icu-devtools libasio-dev libboost-date-time-dev
  libboost-date-time1.74-dev libboost-date-time1.74.0 libboost-dev
  libboost-regex-dev libboost-regex1.74-dev libboost-regex1.74.0
  libboost-serialization1.74-dev libboost-serialization1.74.0 libboost1.74-dev
  libgeographic-dev libgeographic19 libicu-dev python3-click python3-colorama
  python3-wheel ros-humble-diagnostic-updater ros-humble-eigen-stl-containers
  ros-humble-geographic-msgs ros-humble-libmavconn ros-humble-mavlink
  ros-humble-mavros-msgs wget
Suggested packages:
  proj-bin geographiclib-doc libboost-doc libboost1.74-doc
  libboost-atomic1.74-dev libboost-chrono1.74-dev libboost-container1.74-dev
  libboost-context1.74-dev libboost-contract1.74-dev
  libboost-coroutine1.74-dev libboost-exception1.74-dev libboost-fiber1.74-dev
  libboost-filesystem1.74-dev libboost-graph1.74-dev
  libboost-graph-parallel1.74-dev libboost-iostreams1.74-dev
  libboost-locale1.74-dev libboost-log1.74-dev libboost-math1.74-dev
  libboost-mpi1.74-dev libboost-mpi-python1.74-dev libboost-numpy1.74-dev
  libboost-program-options1.74-dev libboost-python1.74-dev
  libboost-random1.74-dev libboost-stacktrace1.74-dev libboost-system1.74-dev
  libboost-test1.74-dev libboost-thread1.74-dev libboost-timer1.74-dev
  libboost-type-erasure1.74-dev libboost-wave1.74-dev libboost1.74-tools-dev
  libmpfrc++-dev libntl-dev libboost-nowide1.74-dev icu-doc
The following NEW packages will be installed:
  geographiclib-tools icu-devtools libasio-dev libboost-date-time-dev
  libboost-date-time1.74-dev libboost-date-time1.74.0 libboost-dev
  libboost-regex-dev libboost-regex1.74-dev libboost-regex1.74.0
  libboost-serialization1.74-dev libboost-serialization1.74.0 libboost1.74-dev
  libgeographic-dev libgeographic19 libicu-dev python3-click python3-colorama
  python3-pip python3-wheel ros-humble-diagnostic-updater
  ros-humble-eigen-stl-containers ros-humble-geographic-msgs
  ros-humble-libmavconn ros-humble-mavlink ros-humble-mavros
  ros-humble-mavros-extras ros-humble-mavros-msgs wget
0 upgraded, 29 newly installed, 0 to remove and 17 not upgraded.
Need to get 31.7 MB of archives.
After this operation, 284 MB of additional disk space will be used.
Get:1 http://packages.ros.org/ros2/ubuntu jammy/main amd64 ros-humble-diagnostic-updater amd64 3.0.0-1jammy.20221019.160314 [96.4 kB]
Get:2 http://archive.ubuntu.com/ubuntu jammy/main amd64 wget amd64 1.21.2-2ubuntu1 [367 kB]
Get:3 http://packages.ros.org/ros2/ubuntu jammy/main amd64 ros-humble-eigen-stl-containers amd64 1.0.0-4jammy.20220519.235231 [7734 B]
Get:4 http://packages.ros.org/ros2/ubuntu jammy/main amd64 ros-humble-geographic-msgs amd64 1.0.4-6jammy.20221019.140423 [191 kB]
Get:5 http://packages.ros.org/ros2/ubuntu jammy/main amd64 ros-humble-mavlink amd64 2022.8.8-1jammy.20220811.181300 [851 kB]
Get:6 http://archive.ubuntu.com/ubuntu jammy/universe amd64 libgeographic19 amd64 1.52-1 [258 kB]
Get:7 http://archive.ubuntu.com/ubuntu jammy/universe amd64 geographiclib-tools amd64 1.52-1 [180 kB]
Get:8 http://archive.ubuntu.com/ubuntu jammy/main amd64 icu-devtools amd64 70.1-2 [197 kB]
Get:9 http://archive.ubuntu.com/ubuntu jammy/universe amd64 libasio-dev all 1:1.18.1-1 [352 kB]
Get:10 http://archive.ubuntu.com/ubuntu jammy/main amd64 libboost1.74-dev amd64 1.74.0-14ubuntu3 [9609 kB]
Get:11 http://packages.ros.org/ros2/ubuntu jammy/main amd64 ros-humble-libmavconn amd64 2.3.0-1jammy.20220930.224216 [114 kB]
Get:12 http://packages.ros.org/ros2/ubuntu jammy/main amd64 ros-humble-mavros-msgs amd64 2.3.0-1jammy.20221019.141156 [957 kB]
Get:13 http://packages.ros.org/ros2/ubuntu jammy/main amd64 ros-humble-mavros amd64 2.3.0-1jammy.20221019.162320 [1518 kB]
Get:14 http://archive.ubuntu.com/ubuntu jammy/main amd64 libboost-date-time1.74.0 amd64 1.74.0-14ubuntu3 [221 kB]
Get:15 http://archive.ubuntu.com/ubuntu jammy/main amd64 libboost-serialization1.74.0 amd64 1.74.0-14ubuntu3 [327 kB]
Get:16 http://archive.ubuntu.com/ubuntu jammy/main amd64 libboost-serialization1.74-dev amd64 1.74.0-14ubuntu3 [375 kB]
Get:17 http://archive.ubuntu.com/ubuntu jammy/main amd64 libboost-date-time1.74-dev amd64 1.74.0-14ubuntu3 [226 kB]
Get:18 http://archive.ubuntu.com/ubuntu jammy/universe amd64 libboost-date-time-dev amd64 1.74.0.3ubuntu7 [3248 B]
Get:19 http://archive.ubuntu.com/ubuntu jammy/main amd64 libboost-dev amd64 1.74.0.3ubuntu7 [3490 B]
Get:20 http://archive.ubuntu.com/ubuntu jammy/main amd64 libboost-regex1.74.0 amd64 1.74.0-14ubuntu3 [511 kB]
Get:21 http://archive.ubuntu.com/ubuntu jammy/main amd64 libicu-dev amd64 70.1-2 [11.6 MB]
Get:22 http://packages.ros.org/ros2/ubuntu jammy/main amd64 ros-humble-mavros-extras amd64 2.3.0-1jammy.20221019.165337 [1215 kB]
Get:23 http://archive.ubuntu.com/ubuntu jammy/main amd64 libboost-regex1.74-dev amd64 1.74.0-14ubuntu3 [596 kB]
Get:24 http://archive.ubuntu.com/ubuntu jammy/main amd64 libboost-regex-dev amd64 1.74.0.3ubuntu7 [3510 B]
Get:25 http://archive.ubuntu.com/ubuntu jammy/universe amd64 libgeographic-dev amd64 1.52-1 [435 kB]
Get:26 http://archive.ubuntu.com/ubuntu jammy/main amd64 python3-colorama all 0.4.4-1 [24.5 kB]
Get:27 http://archive.ubuntu.com/ubuntu jammy/main amd64 python3-click all 8.0.3-1 [78.3 kB]
Get:28 http://archive.ubuntu.com/ubuntu jammy/universe amd64 python3-wheel all 0.37.1-2 [31.9 kB]
Get:29 http://archive.ubuntu.com/ubuntu jammy/universe amd64 python3-pip all 22.0.2+dfsg-1 [1306 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 31.7 MB in 14s (2237 kB/s)
Selecting previously unselected package wget.
(Reading database ... 37549 files and directories currently installed.)
Preparing to unpack .../00-wget_1.21.2-2ubuntu1_amd64.deb ...
Unpacking wget (1.21.2-2ubuntu1) ...
Selecting previously unselected package libgeographic19:amd64.
Preparing to unpack .../01-libgeographic19_1.52-1_amd64.deb ...
Unpacking libgeographic19:amd64 (1.52-1) ...
Selecting previously unselected package geographiclib-tools.
Preparing to unpack .../02-geographiclib-tools_1.52-1_amd64.deb ...
Unpacking geographiclib-tools (1.52-1) ...
Selecting previously unselected package icu-devtools.
Preparing to unpack .../03-icu-devtools_70.1-2_amd64.deb ...
Unpacking icu-devtools (70.1-2) ...
Selecting previously unselected package libasio-dev.
Preparing to unpack .../04-libasio-dev_1%3a1.18.1-1_all.deb ...
Unpacking libasio-dev (1:1.18.1-1) ...
Selecting previously unselected package libboost1.74-dev:amd64.
Preparing to unpack .../05-libboost1.74-dev_1.74.0-14ubuntu3_amd64.deb ...
Unpacking libboost1.74-dev:amd64 (1.74.0-14ubuntu3) ...
Selecting previously unselected package libboost-date-time1.74.0:amd64.
Preparing to unpack .../06-libboost-date-time1.74.0_1.74.0-14ubuntu3_amd64.deb ...
Unpacking libboost-date-time1.74.0:amd64 (1.74.0-14ubuntu3) ...
Selecting previously unselected package libboost-serialization1.74.0:amd64.
Preparing to unpack .../07-libboost-serialization1.74.0_1.74.0-14ubuntu3_amd64.deb ...
Unpacking libboost-serialization1.74.0:amd64 (1.74.0-14ubuntu3) ...
Selecting previously unselected package libboost-serialization1.74-dev:amd64.
Preparing to unpack .../08-libboost-serialization1.74-dev_1.74.0-14ubuntu3_amd64.deb ...
Unpacking libboost-serialization1.74-dev:amd64 (1.74.0-14ubuntu3) ...
Selecting previously unselected package libboost-date-time1.74-dev:amd64.
Preparing to unpack .../09-libboost-date-time1.74-dev_1.74.0-14ubuntu3_amd64.deb ...
Unpacking libboost-date-time1.74-dev:amd64 (1.74.0-14ubuntu3) ...
Selecting previously unselected package libboost-date-time-dev:amd64.
Preparing to unpack .../10-libboost-date-time-dev_1.74.0.3ubuntu7_amd64.deb ...
Unpacking libboost-date-time-dev:amd64 (1.74.0.3ubuntu7) ...
Selecting previously unselected package libboost-dev:amd64.
Preparing to unpack .../11-libboost-dev_1.74.0.3ubuntu7_amd64.deb ...
Unpacking libboost-dev:amd64 (1.74.0.3ubuntu7) ...
Selecting previously unselected package libboost-regex1.74.0:amd64.
Preparing to unpack .../12-libboost-regex1.74.0_1.74.0-14ubuntu3_amd64.deb ...
Unpacking libboost-regex1.74.0:amd64 (1.74.0-14ubuntu3) ...
Selecting previously unselected package libicu-dev:amd64.
Preparing to unpack .../13-libicu-dev_70.1-2_amd64.deb ...
Unpacking libicu-dev:amd64 (70.1-2) ...
Selecting previously unselected package libboost-regex1.74-dev:amd64.
Preparing to unpack .../14-libboost-regex1.74-dev_1.74.0-14ubuntu3_amd64.deb ...
Unpacking libboost-regex1.74-dev:amd64 (1.74.0-14ubuntu3) ...
Selecting previously unselected package libboost-regex-dev:amd64.
Preparing to unpack .../15-libboost-regex-dev_1.74.0.3ubuntu7_amd64.deb ...
Unpacking libboost-regex-dev:amd64 (1.74.0.3ubuntu7) ...
Selecting previously unselected package libgeographic-dev.
Preparing to unpack .../16-libgeographic-dev_1.52-1_amd64.deb ...
Unpacking libgeographic-dev (1.52-1) ...
Selecting previously unselected package python3-colorama.
Preparing to unpack .../17-python3-colorama_0.4.4-1_all.deb ...
Unpacking python3-colorama (0.4.4-1) ...
Selecting previously unselected package python3-click.
Preparing to unpack .../18-python3-click_8.0.3-1_all.deb ...
Unpacking python3-click (8.0.3-1) ...
Selecting previously unselected package python3-wheel.
Preparing to unpack .../19-python3-wheel_0.37.1-2_all.deb ...
Unpacking python3-wheel (0.37.1-2) ...
Selecting previously unselected package python3-pip.
Preparing to unpack .../20-python3-pip_22.0.2+dfsg-1_all.deb ...
Unpacking python3-pip (22.0.2+dfsg-1) ...
Selecting previously unselected package ros-humble-diagnostic-updater.
Preparing to unpack .../21-ros-humble-diagnostic-updater_3.0.0-1jammy.20221019.160314_amd64.deb ...
Unpacking ros-humble-diagnostic-updater (3.0.0-1jammy.20221019.160314) ...
Selecting previously unselected package ros-humble-eigen-stl-containers.
Preparing to unpack .../22-ros-humble-eigen-stl-containers_1.0.0-4jammy.20220519.235231_amd64.deb ...
Unpacking ros-humble-eigen-stl-containers (1.0.0-4jammy.20220519.235231) ...
Selecting previously unselected package ros-humble-geographic-msgs.
Preparing to unpack .../23-ros-humble-geographic-msgs_1.0.4-6jammy.20221019.140423_amd64.deb ...
Unpacking ros-humble-geographic-msgs (1.0.4-6jammy.20221019.140423) ...
Selecting previously unselected package ros-humble-mavlink.
Preparing to unpack .../24-ros-humble-mavlink_2022.8.8-1jammy.20220811.181300_amd64.deb ...
Unpacking ros-humble-mavlink (2022.8.8-1jammy.20220811.181300) ...
Selecting previously unselected package ros-humble-libmavconn.
Preparing to unpack .../25-ros-humble-libmavconn_2.3.0-1jammy.20220930.224216_amd64.deb ...
Unpacking ros-humble-libmavconn (2.3.0-1jammy.20220930.224216) ...
Selecting previously unselected package ros-humble-mavros-msgs.
Preparing to unpack .../26-ros-humble-mavros-msgs_2.3.0-1jammy.20221019.141156_amd64.deb ...
Unpacking ros-humble-mavros-msgs (2.3.0-1jammy.20221019.141156) ...
Selecting previously unselected package ros-humble-mavros.
Preparing to unpack .../27-ros-humble-mavros_2.3.0-1jammy.20221019.162320_amd64.deb ...
Unpacking ros-humble-mavros (2.3.0-1jammy.20221019.162320) ...
Selecting previously unselected package ros-humble-mavros-extras.
Preparing to unpack .../28-ros-humble-mavros-extras_2.3.0-1jammy.20221019.165337_amd64.deb ...
Unpacking ros-humble-mavros-extras (2.3.0-1jammy.20221019.165337) ...
Setting up libboost1.74-dev:amd64 (1.74.0-14ubuntu3) ...
Setting up ros-humble-geographic-msgs (1.0.4-6jammy.20221019.140423) ...
Setting up wget (1.21.2-2ubuntu1) ...
Setting up ros-humble-eigen-stl-containers (1.0.0-4jammy.20220519.235231) ...
Setting up ros-humble-mavlink (2022.8.8-1jammy.20220811.181300) ...
Setting up python3-colorama (0.4.4-1) ...
Setting up libgeographic19:amd64 (1.52-1) ...
Setting up python3-click (8.0.3-1) ...
Setting up python3-wheel (0.37.1-2) ...
Setting up ros-humble-mavros-msgs (2.3.0-1jammy.20221019.141156) ...
Setting up libboost-regex1.74.0:amd64 (1.74.0-14ubuntu3) ...
Setting up icu-devtools (70.1-2) ...
Setting up geographiclib-tools (1.52-1) ...
Setting up python3-pip (22.0.2+dfsg-1) ...
^[[5~Setting up libboost-serialization1.74.0:amd64 (1.74.0-14ubuntu3) ...
Setting up libboost-dev:amd64 (1.74.0.3ubuntu7) ...
Setting up libasio-dev (1:1.18.1-1) ...
Setting up libboost-date-time1.74.0:amd64 (1.74.0-14ubuntu3) ...
Setting up ros-humble-diagnostic-updater (3.0.0-1jammy.20221019.160314) ...
Setting up libicu-dev:amd64 (70.1-2) ...
Setting up ros-humble-libmavconn (2.3.0-1jammy.20220930.224216) ...
Setting up libgeographic-dev (1.52-1) ...
Setting up ros-humble-mavros (2.3.0-1jammy.20221019.162320) ...
Setting up libboost-serialization1.74-dev:amd64 (1.74.0-14ubuntu3) ...
Setting up libboost-regex1.74-dev:amd64 (1.74.0-14ubuntu3) ...
Setting up libboost-regex-dev:amd64 (1.74.0.3ubuntu7) ...
Setting up libboost-date-time1.74-dev:amd64 (1.74.0-14ubuntu3) ...
Setting up ros-humble-mavros-extras (2.3.0-1jammy.20221019.165337) ...
Setting up libboost-date-time-dev:amd64 (1.74.0.3ubuntu7) ...
Processing triggers for libc-bin (2.35-0ubuntu3.1) ...
Removing intermediate container 93687ab076e5
 ---> ea2115ff546a
Step 4/6 : RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh && chmod 777 /temp/install_geographiclib_datasets.sh && /temp/install_geographiclib_datasets.sh
 ---> Running in 7ed6d64dd47a
--2022-11-22 00:37:41--  https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.109.133, 185.199.108.133, 185.199.111.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1244 (1.2K) [text/plain]
Saving to: ‘install_geographiclib_datasets.sh’

     0K .                                                     100% 32.4M=0s

2022-11-22 00:37:41 (32.4 MB/s) - ‘install_geographiclib_datasets.sh’ saved [1244/1244]

Installing GeographicLib geoids egm96-5
Installing GeographicLib gravity egm96
Installing GeographicLib magnetic emm2015
Removing intermediate container 7ed6d64dd47a
 ---> 666c3095081e
Step 5/6 : RUN pip3 install PyGLM
 ---> Running in 5d7e4fd2a70a
Collecting PyGLM
  Downloading PyGLM-2.6.0-cp310-cp310-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl (9.9 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 9.9/9.9 MB 3.4 MB/s eta 0:00:00
Installing collected packages: PyGLM
Successfully installed PyGLM-2.6.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Removing intermediate container 5d7e4fd2a70a
 ---> 2126a9a9657d
Step 6/6 : WORKDIR /ws
 ---> Running in b34b6eb24706
Removing intermediate container b34b6eb24706
 ---> f80a62ac9d11
Successfully built f80a62ac9d11
Successfully tagged usv:latest
foo@bar:~/usv_ws$
foo@bar:~/usv_ws$ docker run -it --mount type=bind,source="$(pwd)",target=/ws usv
root@52414428f42f:/ws# 
root@52414428f42f:/ws# colcon build
Starting >>> autonomy_interfaces
Starting >>> simusv
--- stderr: simusv                                                                  
/usr/lib/python3/dist-packages/setuptools/command/install.py:34: SetuptoolsDeprecationWarning: setup.py install is deprecated. Use build and pip and other standards-based tools.
  warnings.warn(
---
Finished <<< simusv [1.20s]
Finished <<< autonomy_interfaces [7.84s]                     
Starting >>> autonomy
--- stderr: autonomy                   
/usr/lib/python3/dist-packages/setuptools/command/install.py:34: SetuptoolsDeprecationWarning: setup.py install is deprecated. Use build and pip and other standards-based tools.
  warnings.warn(
---
Finished <<< autonomy [1.07s]
Starting >>> autonomy_sim_bringup
Finished <<< autonomy_sim_bringup [0.95s]                   

Summary: 4 packages finished [10.1s]
  2 packages had stderr output: autonomy simusv
root@52414428f42f:/ws#
root@52414428f42f:/ws# source install/setup.bash 
root@52414428f42f:/ws# 
root@52414428f42f:/ws# ros2 launch autonomy_sim_bringup autonomy_sim.launch.py
[INFO] [launch]: All log files can be found below /root/.ros/log/2022-11-22-00-45-58-406861-52414428f42f-911
[INFO] [launch]: Default logging verbosity is set to INFO
[INFO] [cop-1]: process started with pid [912]
[INFO] [boatsim-2]: process started with pid [914]
[cop-1] [INFO] [1669077958.798732660] [COP]: Common Operating Picture node started.
[boatsim-2] [INFO] [1669077960.495832420] [BoatSim]: BoatSim.sim_loop():  1669077960423 before,  1669077960424 after,  0 lapse
[boatsim-2] [INFO] [1669077961.426417551] [BoatSim]: BoatSim.sim_loop():  1669077961423 before,  1669077961424 after,  0 lapse
[boatsim-2] [INFO] [1669077962.426409433] [BoatSim]: BoatSim.sim_loop():  1669077962423 before,  1669077962424 after,  0 lapse
[boatsim-2] [INFO] [1669077963.426385515] [BoatSim]: BoatSim.sim_loop():  1669077963423 before,  1669077963424 after,  0 lapse
[boatsim-2] [INFO] [1669077964.424659091] [BoatSim]: BoatSim.sim_loop():  1669077964423 before,  1669077964423 after,  0 lapse
[boatsim-2] [INFO] [1669077965.426330017] [BoatSim]: BoatSim.sim_loop():  1669077965423 before,  1669077965424 after,  0 lapse
[boatsim-2] [INFO] [1669077966.426664340] [BoatSim]: BoatSim.sim_loop():  1669077966423 before,  1669077966424 after,  0 lapse
[boatsim-2] [INFO] [1669077967.426441917] [BoatSim]: BoatSim.sim_loop():  1669077967423 before,  1669077967424 after,  0 lapse
[boatsim-2] [INFO] [1669077968.426917334] [BoatSim]: BoatSim.sim_loop():  1669077968423 before,  1669077968424 after,  0 lapse
[boatsim-2] [INFO] [1669077969.426244145] [BoatSim]: BoatSim.sim_loop():  1669077969423 before,  1669077969424 after,  0 lapse
[boatsim-2] [INFO] [1669077970.426567482] [BoatSim]: BoatSim.sim_loop():  1669077970423 before,  1669077970424 after,  0 lapse
[boatsim-2] [INFO] [1669077971.426464720] [BoatSim]: BoatSim.sim_loop():  1669077971424 before,  1669077971424 after,  0 lapse
[boatsim-2] [INFO] [1669077972.426952730] [BoatSim]: BoatSim.sim_loop():  1669077972423 before,  1669077972424 after,  0 lapse
[boatsim-2] [INFO] [1669077973.427463412] [BoatSim]: BoatSim.sim_loop():  1669077973424 before,  1669077973424 after,  0 lapse
[boatsim-2] [INFO] [1669077974.426678740] [BoatSim]: BoatSim.sim_loop():  1669077974423 before,  1669077974424 after,  0 lapse
[boatsim-2] [INFO] [1669077975.426317509] [BoatSim]: BoatSim.sim_loop():  1669077975423 before,  1669077975424 after,  0 lapse
[boatsim-2] [INFO] [1669077976.426953233] [BoatSim]: BoatSim.sim_loop():  1669077976423 before,  1669077976424 after,  0 lapse
[boatsim-2] [INFO] [1669077977.427538075] [BoatSim]: BoatSim.sim_loop():  1669077977424 before,  1669077977424 after,  0 lapse
[boatsim-2] [INFO] [1669077978.427355594] [BoatSim]: BoatSim.sim_loop():  1669077978424 before,  1669077978424 after,  0 lapse
[boatsim-2] [INFO] [1669077979.427169995] [BoatSim]: BoatSim.sim_loop():  1669077979424 before,  1669077979424 after,  0 lapse
[boatsim-2] [INFO] [1669077980.426360741] [BoatSim]: BoatSim.sim_loop():  1669077980423 before,  1669077980424 after,  0 lapse
[boatsim-2] [INFO] [1669077981.427874396] [BoatSim]: BoatSim.sim_loop():  1669077981424 before,  1669077981424 after,  0 lapse
[boatsim-2] [INFO] [1669077982.427105707] [BoatSim]: BoatSim.sim_loop():  1669077982423 before,  1669077982424 after,  0 lapse
[boatsim-2] [INFO] [1669077983.427373182] [BoatSim]: BoatSim.sim_loop():  1669077983423 before,  1669077983424 after,  0 lapse
[boatsim-2] [INFO] [1669077984.427358833] [BoatSim]: BoatSim.sim_loop():  1669077984423 before,  1669077984424 after,  0 lapse
[boatsim-2] [INFO] [1669077985.427733860] [BoatSim]: BoatSim.sim_loop():  1669077985424 before,  1669077985425 after,  0 lapse
[boatsim-2] [INFO] [1669077986.424566069] [BoatSim]: BoatSim.sim_loop():  1669077986423 before,  1669077986423 after,  0 lapse
[boatsim-2] [INFO] [1669077987.426751128] [BoatSim]: BoatSim.sim_loop():  1669077987424 before,  1669077987424 after,  0 lapse
[boatsim-2] [INFO] [1669077988.424831844] [BoatSim]: BoatSim.sim_loop():  1669077988423 before,  1669077988423 after,  0 lapse
[boatsim-2] [INFO] [1669077989.427493922] [BoatSim]: BoatSim.sim_loop():  1669077989424 before,  1669077989424 after,  0 lapse
[boatsim-2] [INFO] [1669077990.428062709] [BoatSim]: BoatSim.sim_loop():  1669077990424 before,  1669077990424 after,  0 lapse
[boatsim-2] [INFO] [1669077991.426486624] [BoatSim]: BoatSim.sim_loop():  1669077991424 before,  1669077991424 after,  0 lapse
[boatsim-2] [INFO] [1669077992.426490339] [BoatSim]: BoatSim.sim_loop():  1669077992423 before,  1669077992424 after,  0 lapse
[boatsim-2] [INFO] [1669077993.427017852] [BoatSim]: BoatSim.sim_loop():  1669077993424 before,  1669077993424 after,  0 lapse
[boatsim-2] [INFO] [1669077994.425196302] [BoatSim]: BoatSim.sim_loop():  1669077994423 before,  1669077994424 after,  0 lapse
[boatsim-2] [INFO] [1669077995.425142868] [BoatSim]: BoatSim.sim_loop():  1669077995424 before,  1669077995424 after,  0 lapse
[boatsim-2] [INFO] [1669077996.426377903] [BoatSim]: BoatSim.sim_loop():  1669077996423 before,  1669077996424 after,  0 lapse
[boatsim-2] [INFO] [1669077997.427060329] [BoatSim]: BoatSim.sim_loop():  1669077997424 before,  1669077997424 after,  0 lapse
[boatsim-2] [INFO] [1669077998.427470739] [BoatSim]: BoatSim.sim_loop():  1669077998423 before,  1669077998424 after,  0 lapse
[boatsim-2] [INFO] [1669077999.426593296] [BoatSim]: BoatSim.sim_loop():  1669077999424 before,  1669077999424 after,  0 lapse
[boatsim-2] [INFO] [1669078000.428017328] [BoatSim]: BoatSim.sim_loop():  1669078000424 before,  1669078000424 after,  0 lapse
[boatsim-2] [INFO] [1669078001.424406526] [BoatSim]: BoatSim.sim_loop():  1669078001423 before,  1669078001423 after,  0 lapse
[boatsim-2] [INFO] [1669078002.426626185] [BoatSim]: BoatSim.sim_loop():  1669078002424 before,  1669078002424 after,  0 lapse
[boatsim-2] [INFO] [1669078003.427101324] [BoatSim]: BoatSim.sim_loop():  1669078003423 before,  1669078003424 after,  0 lapse
[boatsim-2] [INFO] [1669078004.425351912] [BoatSim]: BoatSim.sim_loop():  1669078004423 before,  1669078004423 after,  0 lapse
[boatsim-2] [INFO] [1669078005.426499451] [BoatSim]: BoatSim.sim_loop():  1669078005423 before,  1669078005424 after,  0 lapse
[boatsim-2] [INFO] [1669078006.426524131] [BoatSim]: BoatSim.sim_loop():  1669078006423 before,  1669078006424 after,  0 lapse
[boatsim-2] [INFO] [1669078007.426270861] [BoatSim]: BoatSim.sim_loop():  1669078007423 before,  1669078007424 after,  0 lapse
[boatsim-2] [INFO] [1669078008.427174264] [BoatSim]: BoatSim.sim_loop():  1669078008423 before,  1669078008424 after,  0 lapse
[boatsim-2] [INFO] [1669078009.424424870] [BoatSim]: BoatSim.sim_loop():  1669078009423 before,  1669078009423 after,  0 lapse
[boatsim-2] [INFO] [1669078010.426912361] [BoatSim]: BoatSim.sim_loop():  1669078010423 before,  1669078010424 after,  0 lapse
[boatsim-2] [INFO] [1669078011.426337066] [BoatSim]: BoatSim.sim_loop():  1669078011423 before,  1669078011424 after,  0 lapse
[boatsim-2] [INFO] [1669078012.425330515] [BoatSim]: BoatSim.sim_loop():  1669078012423 before,  1669078012423 after,  0 lapse
[boatsim-2] [INFO] [1669078013.424412905] [BoatSim]: BoatSim.sim_loop():  1669078013423 before,  1669078013423 after,  0 lapse
[boatsim-2] [INFO] [1669078014.426020594] [BoatSim]: BoatSim.sim_loop():  1669078014424 before,  1669078014424 after,  0 lapse
[boatsim-2] [INFO] [1669078015.425176709] [BoatSim]: BoatSim.sim_loop():  1669078015424 before,  1669078015424 after,  0 lapse
[boatsim-2] [INFO] [1669078016.427735840] [BoatSim]: BoatSim.sim_loop():  1669078016424 before,  1669078016424 after,  0 lapse
[boatsim-2] [INFO] [1669078017.424939736] [BoatSim]: BoatSim.sim_loop():  1669078017423 before,  1669078017423 after,  0 lapse
[boatsim-2] [INFO] [1669078018.426309551] [BoatSim]: BoatSim.sim_loop():  1669078018423 before,  1669078018424 after,  0 lapse
[boatsim-2] [INFO] [1669078019.426670727] [BoatSim]: BoatSim.sim_loop():  1669078019424 before,  1669078019424 after,  0 lapse
[boatsim-2] [INFO] [1669078020.426358718] [BoatSim]: BoatSim.sim_loop():  1669078020423 before,  1669078020424 after,  0 lapse
[boatsim-2] [INFO] [1669078021.426328604] [BoatSim]: BoatSim.sim_loop():  1669078021423 before,  1669078021424 after,  0 lapse
[boatsim-2] [INFO] [1669078022.426912372] [BoatSim]: BoatSim.sim_loop():  1669078022424 before,  1669078022424 after,  0 lapse
[boatsim-2] [INFO] [1669078023.426666254] [BoatSim]: BoatSim.sim_loop():  1669078023424 before,  1669078023424 after,  0 lapse
[boatsim-2] [INFO] [1669078024.426264170] [BoatSim]: BoatSim.sim_loop():  1669078024423 before,  1669078024424 after,  0 lapse
[boatsim-2] [INFO] [1669078025.427616018] [BoatSim]: BoatSim.sim_loop():  1669078025424 before,  1669078025424 after,  0 lapse
[boatsim-2] [INFO] [1669078026.427555831] [BoatSim]: BoatSim.sim_loop():  1669078026424 before,  1669078026424 after,  0 lapse
[boatsim-2] [INFO] [1669078027.426872892] [BoatSim]: BoatSim.sim_loop():  1669078027424 before,  1669078027424 after,  0 lapse
[boatsim-2] [INFO] [1669078028.426510828] [BoatSim]: BoatSim.sim_loop():  1669078028423 before,  1669078028424 after,  0 lapse
[boatsim-2] [INFO] [1669078029.427343819] [BoatSim]: BoatSim.sim_loop():  1669078029424 before,  1669078029424 after,  0 lapse
[boatsim-2] [INFO] [1669078030.426300660] [BoatSim]: BoatSim.sim_loop():  1669078030423 before,  1669078030424 after,  0 lapse
[boatsim-2] [INFO] [1669078031.426294340] [BoatSim]: BoatSim.sim_loop():  1669078031423 before,  1669078031424 after,  0 lapse
[boatsim-2] [INFO] [1669078032.426798003] [BoatSim]: BoatSim.sim_loop():  1669078032424 before,  1669078032424 after,  0 lapse
[boatsim-2] [INFO] [1669078033.424442557] [BoatSim]: BoatSim.sim_loop():  1669078033423 before,  1669078033423 after,  0 lapse
[boatsim-2] [INFO] [1669078034.425686445] [BoatSim]: BoatSim.sim_loop():  1669078034423 before,  1669078034423 after,  0 lapse
[boatsim-2] [INFO] [1669078035.427047584] [BoatSim]: BoatSim.sim_loop():  1669078035423 before,  1669078035424 after,  0 lapse
[boatsim-2] [INFO] [1669078036.426428232] [BoatSim]: BoatSim.sim_loop():  1669078036423 before,  1669078036424 after,  0 lapse
[boatsim-2] [INFO] [1669078037.426693022] [BoatSim]: BoatSim.sim_loop():  1669078037424 before,  1669078037424 after,  0 lapse
[boatsim-2] [INFO] [1669078038.426532228] [BoatSim]: BoatSim.sim_loop():  1669078038423 before,  1669078038424 after,  0 lapse
[boatsim-2] [INFO] [1669078039.427963039] [BoatSim]: BoatSim.sim_loop():  1669078039423 before,  1669078039424 after,  0 lapse
[boatsim-2] [INFO] [1669078040.426418638] [BoatSim]: BoatSim.sim_loop():  1669078040423 before,  1669078040424 after,  0 lapse
[boatsim-2] [INFO] [1669078041.424369145] [BoatSim]: BoatSim.sim_loop():  1669078041423 before,  1669078041423 after,  0 lapse
[boatsim-2] [INFO] [1669078042.424936835] [BoatSim]: BoatSim.sim_loop():  1669078042423 before,  1669078042423 after,  0 lapse
[boatsim-2] [INFO] [1669078043.426436031] [BoatSim]: BoatSim.sim_loop():  1669078043423 before,  1669078043424 after,  0 lapse
[boatsim-2] [INFO] [1669078044.427472467] [BoatSim]: BoatSim.sim_loop():  1669078044423 before,  1669078044424 after,  0 lapse
[boatsim-2] [INFO] [1669078045.428186895] [BoatSim]: BoatSim.sim_loop():  1669078045424 before,  1669078045424 after,  0 lapse
[boatsim-2] [INFO] [1669078046.426501053] [BoatSim]: BoatSim.sim_loop():  1669078046423 before,  1669078046424 after,  0 lapse
[boatsim-2] [INFO] [1669078047.424243162] [BoatSim]: BoatSim.sim_loop():  1669078047423 before,  1669078047423 after,  0 lapse
[boatsim-2] [INFO] [1669078048.427034187] [BoatSim]: BoatSim.sim_loop():  1669078048423 before,  1669078048424 after,  0 lapse
[boatsim-2] [INFO] [1669078049.426282172] [BoatSim]: BoatSim.sim_loop():  1669078049423 before,  1669078049424 after,  0 lapse
[boatsim-2] [INFO] [1669078050.426357671] [BoatSim]: BoatSim.sim_loop():  1669078050423 before,  1669078050424 after,  0 lapse
[boatsim-2] [INFO] [1669078051.426495793] [BoatSim]: BoatSim.sim_loop():  1669078051424 before,  1669078051424 after,  0 lapse
[boatsim-2] [INFO] [1669078052.426507407] [BoatSim]: BoatSim.sim_loop():  1669078052423 before,  1669078052424 after,  0 lapse
[boatsim-2] [INFO] [1669078053.427258115] [BoatSim]: BoatSim.sim_loop():  1669078053424 before,  1669078053424 after,  0 lapse
[boatsim-2] [INFO] [1669078054.428034268] [BoatSim]: BoatSim.sim_loop():  1669078054424 before,  1669078054424 after,  0 lapse
[boatsim-2] [INFO] [1669078055.424648728] [BoatSim]: BoatSim.sim_loop():  1669078055423 before,  1669078055423 after,  0 lapse
[boatsim-2] [INFO] [1669078056.425724248] [BoatSim]: BoatSim.sim_loop():  1669078056423 before,  1669078056424 after,  0 lapse
[boatsim-2] [INFO] [1669078057.426385094] [BoatSim]: BoatSim.sim_loop():  1669078057423 before,  1669078057424 after,  0 lapse
[boatsim-2] [INFO] [1669078058.426930042] [BoatSim]: BoatSim.sim_loop():  1669078058424 before,  1669078058424 after,  0 lapse
[boatsim-2] [INFO] [1669078059.427023913] [BoatSim]: BoatSim.sim_loop():  1669078059424 before,  1669078059424 after,  0 lapse
[boatsim-2] [INFO] [1669078059.429632130] [BoatSim]: Run_limit of 100 reached, exiting.
[boatsim-2] [INFO] [1669078060.426491151] [BoatSim]: BoatSim.sim_loop():  1669078060423 before,  1669078060424 after,  0 lapse
[boatsim-2] [INFO] [1669078060.429532255] [BoatSim]: Run_limit of 100 reached, exiting.
```


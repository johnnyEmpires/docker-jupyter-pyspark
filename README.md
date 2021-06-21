# docker-jupyter-pyspark

I wrote this guide to practice using docker, so I decided to use pyspark in a jupyter notebook for the sake of this guide.

## Prerequisites

* [docker](https://www.docker.com/)

## Setup

1. You may clone this repository or create a specific directory for this guide. Let's call the setup directory as `docker-jupyter-pyspark` for the sake of explanation.
2. Change directory to `docker-jupyter-pyspark` folder, then create docker file called `Dockerfile`. See [About the Dockerfile](#about-the-Dockerfile) section explanation.
3. Build the docker image using the `Dockerfile` by specfying `docker-jupyter` as image name by using `-t` or `--tag` option, the `.` indicates that the `Dockerfile` is within the current directory.

```
docker build -t docker-jupyter .
```

A new docker image will be created with a name `docker-jupyter`. You can check existing docker images using the docker desktop application or by following command.

```
docker images -a
```

You should see `docker-jupyter` listed if build process was successful.

```
C:\projects\python\docker-jupyter-pyspark>docker images -a
REPOSITORY       TAG       IMAGE ID       CREATED      SIZE
docker-jupyter   latest    46f171d2b2ef   2 hours ago  1.34GB
```

4. Creating and running a container based from the created image using below command with the some options.

```
docker run -d -t -p 8888:8888 --mount src="C:\docker",target=/home/,type=bind  --name jupyter-container docker-jupyter
```

**Notes**

* `docker run` creates and starts the container.
* `-d` runs the container in background.
* `-t` allows us to later access the terminal within the container.
* `-p 8888:8888` connects the container port `8888` to your host machine.
* `--mount src="C:\docker",target=/home/,type=bind` allows us to share data between the container and the host machine. `src` will specific the location in the host machine to share the data, create first this location before using this option.
* `--name jupyter-container` assigns the name to the container which can be used later to start/stop the container.
* `docker-jupyter` tells the docker which image to use when creating the container.

Check running container using `docker ps -a` command.

```
C:\projects\python\docker-jupyter-pyspark>docker ps -a
CONTAINER ID   IMAGE            COMMAND       CREATED         STATUS                    PORTS                                       NAMES
2773aafd477a   docker-jupyter   "/bin/bash"   5 seconds ago   Up 4 seconds              0.0.0.0:8888->8888/tcp, :::8888->8888/tcp   jup-con
```

5. Access the container using `docker exec` command. The terminal to your container should open after executing below command.

```
docker exec -it jup-con /bin/bash
```

6. To use `pyspark`, we have to install `java`. There reason it is not included `Dockerfile` is that I have not found a way yet to auto answer the prompt during installation such as region setup. within the terminal run below command and respond to the prompts during installation.

```
apt install default-jre
```
7. Now we should be able to run `jupyter` and access it in the host machine. Use `jupyter-notebook` with the following command to allow access to the host machine. We can also use `"*"` inplace of `0.0.0.0`.

```
jupyter notebook --ip 0.0.0.0 --no-browser --allow-root
```

Then access the link provided after above command.

```
oot@2773aafd477a:/home# jupyter notebook --ip 0.0.0.0 --no-browser --allow-root
[I 01:44:27.514 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
[I 01:44:27.901 NotebookApp] Serving notebooks from local directory: /home
[I 01:44:27.901 NotebookApp] Jupyter Notebook 6.4.0 is running at:
[I 01:44:27.901 NotebookApp] http://2773aafd477a:8888/?token=cbcdd2cf01c30f801f3f33366795b2b5c250cbd1a05e3a68
[I 01:44:27.901 NotebookApp]  or http://127.0.0.1:8888/?token=cbcdd2cf01c30f801f3f33366795b2b5c250cbd1a05e3a68
[I 01:44:27.901 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 01:44:27.906 NotebookApp] 

    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-29-open.html
    Or copy and paste one of these URLs:
        http://2773aafd477a:8888/?token=cbcdd2cf01c30f801f3f33366795b2b5c250cbd1a05e3a68
     or http://127.0.0.1:8888/?token=cbcdd2cf01c30f801f3f33366795b2b5c250cbd1a05e3a68
```
**Note**
* to stop `jupyter` just hit `ctrl-c`.

8. To stop the container, use `docker stop` command.

```
docker stop jup-con
```

9. To restart the container use the `docker start` command.

```
docker start jup-con
```

10. And to access again the running container, use same command from step `5`.

```
docker exec -it jup-con /bin/bash
```

## About the Dockerfile

`Dockerfile` contains the following lines for creating the docker image with the necessary dependecies installed.

```
FROM ubuntu:20.04

RUN apt-get -y update
RUN apt-get -y install python3 python3-pip
RUN apt-get -y install vim
RUN python3 -m pip install jupyter pandas pyspark
```

Using the `ubuntu` version `20.04` as base image. We can also use the latest image but I have not tested.

```
FROM ubuntu:20.04
```

Update the os and install `python3` and `pip`. Use the `-y` command to auto-accept any prompt during the installation.

```
RUN apt-get -y update
RUN apt-get -y install python3 python3-pip
```
`vim` does not come pre-installed in the base image, let's install it in case we needed to edit something within the os.

```
RUN apt-get -y install vim
```

Finally, let's install `jupyter` and `pyspark`, I also installed `pandas` in case I needed it, although I am no sure if it will come pre-installed when `pyspark` is installed.

```
RUN python3 -m pip install jupyter pandas pyspark
```
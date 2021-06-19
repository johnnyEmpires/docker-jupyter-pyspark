FROM ubuntu:20.04

RUN apt-get -y update
RUN apt-get -y install python3 python3-pip
RUN apt-get -y install vim
RUN python3 -m pip install jupyter pandas pyspark
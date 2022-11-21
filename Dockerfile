FROM ros:humble

WORKDIR /temp
RUN apt-get update && apt-get install -y ros-humble-mavros ros-humble-mavros-extras python3-pip
RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh && chmod 777 /temp/install_geographiclib_datasets.sh && /temp/install_geographiclib_datasets.sh

RUN pip3 install PyGLM

WORKDIR /ws
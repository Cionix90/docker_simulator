
# base image osrf/ros tag humble-desktop-full
ARG BASE_IMAGE=osrf/ros
ARG BASE_TAG=humble-desktop-full
FROM ${BASE_IMAGE}:${BASE_TAG}

# set the environment variable with the command ENV <key>=<value>, it can be replaced online
ENV DEBIAN_FRONTEND=noninteractive

# RUN is used to execute and add new layer on top of the base immage

RUN apt-get update \
    && apt-get install -y \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-ros2-control \
    ros-humble-joint-state-publisher \
    ros-humble-joint-state-publisher-gui \
    ros-humble-ros-ign-bridge \
    ros-humble-ign-ros2-control \
    ros-humble-ign-ros2-control-demos \
    ros-humble-teleop-twist-joy \
    ros-humble-joy \
    ros-humble-pinocchio \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-xacro \
    ros-humble-rosbag2-storage-mcap \
    ros-humble-plotjuggler-ros \
    chrony \
    tmux python3-pip\
    xterm \
    libeigen3-dev \
    nano \
    ros-humble-rviz2 \
    nautilus \ 
    iputils-ping \
    iproute2  \
    python3-rosdep \
    && apt-get clean
# install 
# Adapt your desired python version here    
# ENV PATH=/opt/openrobots/bin:$PATH 
# ENV PKG_CONFIG_PATH=/opt/openrobots/lib/pkgconfig:$PKG_CONFIG_PATH 
# ENV LD_LIBRARY_PATH=/opt/openrobots/lib:$LD_LIBRARY_PATH 
# ENV PYTHONPATH=/opt/openrobots/lib/python3.10/site-packages:$PYTHONPATH  
# ENV CMAKE_PREFIX_PATH=/opt/openrobots:$CMAKE_PREFIX_PATH
# ENV TERM=xterm-256color

ENV DEBIAN_FRONTEND=dialog

# Create a new user
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && apt-get update \
    && apt-get install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

#Change HOME environment variable
ENV HOME /home/${USERNAME}

# Choose to run as user
ENV USER ${USERNAME}

USER ${USERNAME}

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# Install the python packages cosi non vengono installati da root
RUN pip3 install \
    numpy \
    numpy-quaternion \
    quadprog \
    scipy \
    --upgrade
# Set up auto-source of workspace for ros user
ARG WORKSPACE=docker_navigation

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo 'source /usr/share/gazebo/setup.bash' >> ~/.bashrc
RUN echo "if [ -f ~/${WORKSPACE}/install/setup.bash ]; then source ~/${WORKSPACE}/install/setup.bash; fi" >> /home/ros/.bashrc

ENTRYPOINT ["/ros_entrypoint.sh"]

# base image osrf/ros tag humble-desktop-full
ARG BASE_IMAGE=osrf/ros
ARG BASE_TAG= jazzy-desktop-full

FROM ${BASE_IMAGE}:${BASE_TAG}

# set the environment variable with the command ENV <key>=<value>, it can be replaced online
ENV DEBIAN_FRONTEND=noninteractive
ENV GZ_VERSION=harmonic
## arg ros2 distro 
ARG DISTRO=humble
# RUN is used to execute and add new layer on top of the base immage
RUN apt-get update 


RUN apt-get install -y ros-${DISTRO}-plotjuggler
RUN apt-get install -y ros-${DISTRO}-ros-gz
RUN apt-get install -y \
    ros-${DISTRO}-joint-state-publisher \
    ros-${DISTRO}-joint-state-publisher-gui \
    ros-${DISTRO}-gz-ros2-control \
    ros-${DISTRO}-teleop-twist-joy \
    ros-${DISTRO}-joy \
    ros-${DISTRO}-pinocchio \
    ros-${DISTRO}-ros2-control \
    ros-${DISTRO}-ros2-controllers \
    ros-${DISTRO}-xacro \
    ros-${DISTRO}-rosbag2-storage-mcap \
    ros-${DISTRO}-plotjuggler-ros \
    pipx \
    chrony \
    tmux python3-pip\
    xterm \
    libeigen3-dev \
    nano \
    ros-${DISTRO}-rviz2 \
    nautilus \ 
    iputils-ping \
    iproute2  \
    python3-rosdep \
    && apt-get clean
RUN apt-get install -y  curl lsb-release gnupg
RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg 
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
RUN echo " CURL DONE"

RUN sudo  apt-get update 
RUN sudo apt-get install -y gz-harmonic
RUN echo "Ignition Installed"

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
RUN if id -u ${USER_UID} ; then userdel `id -un ${USER_UID}` ; fi
RUN groupadd --gid ${USER_GID} ${USERNAME} 
RUN useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && apt-get update \
    && apt-get install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

#Change HOME environment variable
ENV HOME=/home/${USERNAME}
# Choose to run as user
ENV USER=${USERNAME}

USER ${USERNAME}

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# Install the python packages cosi non vengono installati da root
RUN pipx install numpy 
# install gazebo ignition
# RUN sudo apt-get install -y  curl lsb-release gnupg
# RUN sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpgecho "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
# RUN echo " CURL DONE"

# Set up auto-source of workspace for ros user
ARG WORKSPACE=docker_navigation

RUN echo "source /opt/ros/${DISTRO}/setup.bash" >> ~/.bashrc

RUN echo "if [ -f ~/${WORKSPACE}/install/setup.bash ]; then source ~/${WORKSPACE}/install/setup.bash; fi" >> /home/ros/.bashrc
RUN echo "export GZ_SIM_SYSTEM_PLUGIN_PATH=/opt/ros/humble/lib/" >> ~/.bashrc
RUN sudo ln -s /usr/include/eigen3/Eigen /usr/include/Eigen
# install gazebo ignition


ENTRYPOINT ["/ros_entrypoint.sh"]
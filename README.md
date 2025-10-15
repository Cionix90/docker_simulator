# Dockerized Gazebo Harmonic Simulator

## Introduction
This repository contains a Docker Compose setup for simulating robots in **Gazebo Sim Fortress**, integrated with **ROS 2 Humble** on **Ubuntu 22.04**.  
The purpose of this repository is to provide an easy setup for robotic software developers to test their own controllers in simulation.

## Prerequisites

- **Docker Engine:** Follow the [Docker Engine installation guide](https://docs.docker.com/engine/install/ubuntu/), then enable Docker usage as a non-root user as described [here](https://docs.docker.com/engine/install/linux-postinstall/).

- **NVIDIA Driver:** Follow the [NVIDIA Display Driver installation guide](https://github.com/oddmario/NVIDIA-Ubuntu-Driver-Guide).

- **NVIDIA Container Toolkit:** Install the NVIDIA Container Toolkit by following [this guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

## Clone and Initialize the Repository

This repository uses **git submodules** to include different robot packages.  
To clone the main repository, run:

```bash
git clone https://github.com/Cionix90/docker_simulator.git
```

Then initialize all submodules recursively:

```bash
git submodule update --init --recursive
```

## Build

```bash
compose_build.bash
```

## Start the Compose Environment

```bash
docker compose up -d
```

Then open a shell inside the ROS 2 container:

```bash
docker compose exec ros2_shell bash
```

## Test NVIDIA Support

To verify that NVIDIA GPU support is working correctly, start the container and run:

```bash
nvidia-smi
```

## Add Local Worlds and Models

To add a local SDF world or model file, simply place the desired files inside the `gazebo_models` package, under the corresponding `worlds` or `models` folder.  
Then rebuild the environment to include the new files.

## Available Robots

The following robots are included in this repository:

- **Agilex [Scout 2.0](https://global.agilex.ai/products/scout-2-0):** 4WD mobile base  
- **Agilex [Hunter SE](https://global.agilex.ai/products/hunter-se):** Ackermann-drive mobile base  
- **Mulinex [Omnicar](https://www.centropiaggio.unipi.it/~garabini):** Mecanum-wheel mobile base  

## Start the Simulator

To start a Gazebo Ignition simulation, use the command:

```bash
ign gazebo <world_name>
```

For a better understanding of Gazebo Ignition usage, see the [official documentation](https://gazebosim.org/docs/fortress/tutorials/).

## Spawn a Robot

Each robot has its own package containing a URDF model and a spawn launch file.  
To spawn a robot into the active simulation, run:

```bash
ros2 launch mulinex_ignition/scout_description/hunter_se_description spawn_robot.launch.py
```

This launch file accepts several arguments:

- `spawn_pos_x`, `spawn_pos_y`, `spawn_pos_z`: specify the robot’s initial position  
- `robot_name`: specify a unique name to spawn multiple robots (each will have its own namespace and controller manager)  
- `joystick_teleop`: enable joystick teleoperation (not supported for multi-robot spawning)
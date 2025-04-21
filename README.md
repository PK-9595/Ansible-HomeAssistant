# Ansible Home Assistant Automation

This project provides an automated way to set up and maintain **Home Assistant Core** on a Raspberry Pi or Ubuntu Linux server using **Ansible**. It helps automate provisioning and updating tasks, ensuring a streamlined setup experience.

## Features
- Easy-to-use playbook for provisioning and updates.
- Automated deployment of Home Assistant as a Docker container.
- Includes setup for popular add-ons like MQTT (Mosquitto) and HACS.



<br><br><br>



## PREREQUISITES & SETUP
There are 2 main components required:

### 1. Home Assistant Server
A working Raspberry Pi or Linux server using the `apt` package manager. Home Assistant Core will run here as a Docker container. A Zigbee dongle might be required to send and receive Zigbee signals if needed for your smart home setup.

#### Setup Steps:

- **Create a user for Ansible to connect:**
  1. Run the following command to create a user with a home directory and password:  
     ```bash
     sudo adduser <username>
     ```
     Follow the prompts to complete the setup.
  2. Grant the user sudo privileges:  
     Open the sudoers file using:  
     ```bash
     sudo visudo
     ```
     Add the following line under `#User privilege specification`:  
     ```
     <username> ALL=(ALL:ALL) NOPASSWD: ALL
     ```

- **Enable SSH service:**
  ```bash
  sudo systemctl enable ssh && sudo systemctl start ssh
  ```

<br>

### 2. Ansible Control Machine
Another server where ansible will be installed

#### Setup Steps:

- **Update the System & Install Necessary Packages (below instructions for linux servers with the apt package manager):**
  1. Update the package list:  
     ```bash
     sudo apt update
     ```
  2. Install Python package manager:  
     ```bash
     sudo apt install pipx python3-venv
     pipx ensurepath
     ```
  3. Install Ansible via pip:  
     ```bash
     pipx install ansible
     ```
  4. Install Ansible Docker collections:  
     ```bash
     ansible-galaxy collection install community.docker
     ansible-galaxy collection install community.general
     ```
  5. Install Git:  
     ```bash
     sudo apt install git
     ```
- **Setup SSH Connection to the Home Assistant Server:**
  1. Generate an SSH key pair (preferably save the keys in `~/.ssh` directory):  
     ```bash
     ssh-keygen
     ```
  2. Start the SSH agent:  
     ```bash
     eval "$(ssh-agent -s)"
     ```
  3. Add the private key to the SSH agent:  
     ```bash
     ssh-add <privKeyFilePath>
     ```
  4. Copy the public key to the Home Assistant server's authorized_keys file:  
     ```bash
     ssh-copy-id -i <pubKeyFilePath> <username>@<hostName>
     ```
     Replace `<username>` and `<hostName>` with the appropriate values.  
     *Initial SSH connection can be done through password authentication.*



<br><br>



## HOME ASSISTANT SETUP VIA ANSIBLE:
1. Clone this repository to the ansible control machine:  
    ```bash
    git clone git@github.com:PK-9595/Ansible-HomeAssistant.git
    ```
2. Enter the Ansible-HomeAssistant Project Directory:  
    ```bash
    cd Ansible-HomeAssistant
    ```
3. In the project root directory, rename `.env.example` file to `.env`:
    ```bash
    mv .env.example .env
    ```
4. Edit variables saved in the `.env` file:
    ```bash
    vim .env
    ```
    *Feel free to use any editor of your choice*
5. Load the desired variables in the `.env` file and run the ansible playbook through the script:
    ```bash
    source load_env.sh
    ```
    *This step can be done repeatedly as and when needed to update home assistant*


<br>


## ADD-ONS SET UP & WEB UI USAGE:

### HOME ASSISTANT WEB UI USAGE:
To access the home assistant web UI, connect to port 8123 of the home assistant server on any web browser of any device connected to the same local network.

### ADD-ONS SET UP:

#### Mosquitto Broker
- To connect to the mosquitto broker (no longer supported via YAML) > access the home assistant web UI > `Settings` > `Devices & Services` > `ADD INTEGRATION` > `MQTT` > Enter Broker as `mosquitto-HA` and port as `1883`.

#### HACS
- To setup HACs > access the home assistant web UI > `Settings` > `Devices & Services` > `ADD INTEGRATION` > `HACS` > Follow the link to github for authorization.

#### Node-RED
- To setup nodered > access the nodered web UI (`http://[ip-address]:1880`) > Go to `Manage Palette` on the right-hand menu > Search for and install `node-red-contrib-home-assistant-websocket` > go to home assistant web UI to generate a long term access key (store it!) > back in nodered web UI, add server through any home assistant node; you will need the access key and the `hostname:port` (docker DNS name: http://homeAssistant:8123).
You may now make configurations in nodered and customize automations, scenes, and triggers.

#### Xiaomi Miot Auto
- To add xiaomi miot integration, access the home assistant web UI > `HACS` > search `Xiaomi Miot Auto` > `DOWNLOAD` > follow prompt to restart home assistant > `Settings` > `Devices & Services` > `ADD INTEGRATION` > `Xiaomi Miot Auto` > Follow the process for further setup.

#### Localtuya
- To add Localtuya integration, access the home assistant web UI > `HACS` > click the 3 dots > `Custom repositories` > `https://github.com/xZetsubou/hass-localtuya`, type `Integration` > `DOWNLOAD` > follow prompt to restart home assistant > `Settings` > `Devices & Services` > `ADD INTEGRATION` > `LocalTuya integration` > 
For further information on how to configure devices, refer to the `README.md` file in Localtuya found in HACS.


<br><br><br>

## TROUBLESHOOTING / COMMON ERRORS
- Sometimes a virtual network interface will be assigned as the default route in the routing table, this disables outbound internet access for the device. This could be caused by `connman`. One way of solving such an issue is by disabling `connman` and switching to a different network manager, others have also found success through blacklisting certain interfaces in `/etc/connman/main.conf` file.


<br><br>

## BRIEF ANSIBLE PLAYBOOK EXPLANATION:

There are a few main things ansible performs in the playbook, performed by the multiple roles present:
1. Install python so ansible can run using its other modules.
2. Setup key-based SSH authentication & disable password-based authentication.
3. Update the system and download packages, some necessary, and some for convenience.
4. Preventing rfkill from blocking/disabling wifi & bluetooth by default.
5. Configuring the user environment (E.g., default shell, text editor).
6. Download and setup Docker & Docker Compose.
7. Setup Files & Directories needed for Home Assistant & Add-Ons.
8. Initialize Home Assistant-related config files by initializing the Docker containers.
9. Setting up & Updating add-ons to home assistant such as HACs.
10. Run docker containers for operation.
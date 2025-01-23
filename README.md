This project aims to use ansible to automate the process of setting up home assistant core on a raspberry pi / ubuntu linux server alongside certain add-ons. It can be run to perform provisioning or updating.

HARDWARE REQUIREMENTS:
1. Home Assistant Server - A working raspberry pi or linux server using the `apt` package manager. This is where Home Assistant Core will run as a docker container. A zigbee dongle might be required to receive and send zigbee signals - if needed in your smart home setup.
2. Ansible Control Machine - Another server where ansible will be installed.

ANSIBLE & SSH SETUP:
SSH connection from the ansible control machine to a selected user (with sudo privileges) on the home assistant server via SSH key is required. Follow the below instructions to perform setup:
- Create a user on the home assistant server for ansible to connect as:
    - Create a desired user, a home directory, and password for that user using the `adduser <username>` CLI command and following through with the prompts.
    - Giving sudo privileges to the user (`sudo visudo` then adding `<username> ALL=(ALL:ALL) NOPASSWD: ALL` below `#User privilege specification`)
- Run the SSH service on the home assistant server using `sudo systemctl enable ssh && sudo systemctl start ssh` CLI command.
- Go to the ansible control machine, then setup SSH connection to the home assistant server:
    - Create an SSH key-pair using the `ssh-keygen` CLI command, preferably saving the keys in `~/.ssh` directory.
    - Run `eval "$(ssh-agent -s)"` CLI command.
    - Add the private key to your ssh agent using `ssh-add <privKeyFilePath>` CLI command.
    - Copy the public key over to your raspberry pi/linux server's authorized_keys file using `ssh-copy-id -i <pubKeyFilePath> <username>@<hostName>` CLI command, where hostname and username refers to the hostname of the home assistant server, and the user previously created there, respectively.
- Setup ansible on the ansible control machine:
    - Run `sudo apt install -y ansible` CLI command.
    - Run `ansible-galaxy collection install community.docker` CLI command.

INSTRUCTIONS:
- Clone this repository to the ansible control machine.
- In the project root directory, edit variables saved in the `.env.example` file accordingly and rename the file to `.env`
- While in the project root directory, run `source load_env.sh`. This command can be run repeatedly to update the home assistant server.

GUI Set Up & Usage:
- To access the home assistant web UI, connect to port 8123 of the home assistant server on any web browser of any device connected to the same local network.
- To connect to the mosquitto broker (no longer supported via YAML) > access the home assistant web UI > `Settings` > `Devices & Services` > `ADD INTEGRATION` > `MQTT` > Enter Broker as `mosquitto-HA` and port as `1883`.
- To add xiaomi miot integration, use the browser web UI as well.


EXPLANATION:

There are a few main things ansible performs in the playbook, performed by the multiple roles present:
1. Install python so ansible can run using its other modules.
2. Setup key-based SSH authentication & disable password-based authentication.
3. Update the system and download packages, some necessary, and some for convenience.
4. Preventing rfkill from blocking/disabling wifi & bluetooth by default.
5. Configuring the user environment (E.g., default shell, text editor).
6. Download and setup Docker & Docker Compose.
7. Setup Files & Directories needed for Home Assistant & Add-Ons.
8. Initialize Home Assistant-related config files by initializing the Docker containers.
9. Setting up & Updating add-ons to home assistant such as HACs or xiaomi miot integration.
10. Run docker containers for operation.
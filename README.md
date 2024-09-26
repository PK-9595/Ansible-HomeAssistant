This project aims to automate the process of setting up home assistant on a raspberry pi / ubuntu linux server

INSTRUCTIONS:

Ensure SSH connection to a selected user on a working raspberry pi / linux server (via SSH key) from your personal laptop
- On your working raspberry pi/linux server (where home assistant will be installed)
    User Creation:
    - Creating a desired user and a home directory for that user (`useradd` or `adduser`)
    - Setting a password (`passwd $USER`)
    - Giving sudo privileges to the user (`sudo visudo` then adding `? ALL=(ALL:ALL) NOPASSWD: ALL` below `#User privilege specification` where `?` is a placeholder for the username)
    SSH Setup:
    - Run `sudo systemctl enable ssh && sudo systemctl start ssh`
- On your personal laptop:
    - Create an SSH key-pair `ssh-keygen` or any type of your choice
    - Add the private key to your ssh agent `ssh-add privKeyFilePath`
    - Copy the public key over to your raspberry pi/linux server's authorized_keys file `ssh-copy-id -i pubKeyFilePath username@hostname` when username and hostname refers to the user previously created in your raspberry pi/linux server, and the name of the server.
- Download ansible on your personal laptop
- Clone this repository on your personal laptop, then enter the project directory
- Edit variables saved in .env.example accordingly and rename the file to .env
- Load environment variables from .env (run `source load_env.sh`)
- Run ansible playbook `ansible-playbook -i inventory playbook.yml` 


TROUBLESHOOTING:
- If there are issues resolving the hostname, enter the IP address instead of the hostname
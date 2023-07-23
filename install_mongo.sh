#!/bin/bash
# Author: Nirbhay Singh
# Source: https://github.com/Nirbhay4122/BashScripting.git
# This script will install mongoDB on all version of Ubuntu & Debian.
DETECT_OS() { 
    if ! command -v lsb_release >/dev/null 2>&1; then
        sudo apt update -y
        sudo apt install lsb-release -y
    fi
    OS_VERSION=$(lsb_release -sr); OS_ID=$(lsb_release -si); OS_CODENAME=$(lsb_release -sc);
}
START_MONGO_SERVICE() {
    sudo systemctl start mongod.service
    sudo systemctl enable mongod.service
}
INSTALL_MONGO() {
    DETECT_OS; if [ "${OS_ID,,}" == "ubuntu" ] || [ "${OS_ID,,}" == "debian" ]; then
        packages=('gnupg' 'curl'); for pkg in ${packages[@]}; do if dpkg -s ${pkg} >/dev/null 2>&1; then echo -e "[Info] ${pkg} Already installed."; else apt-get install $pkg; fi done
        read -p "Select MongoDB Version - [ 4.4, 5.0, 6.0 ] " MONGO_VERSION;
        if [ "${OS_ID,,}" == "ubuntu" ]; then
            if [ "${OS_VERSION%.*}" == "22" ]; then
                if [ "${MONGO_VERSION}" == "6.0" ]; then
                    MONGO_VERSION=6.0;
                else
                    echo "Detected ${OS_ID,,}-${OS_VERSION}, there will be only availabe mongoDB version { 6.0 }"
                    read -p "To continue press [Y/y] / any key to exit: " CONDITION
                    if [ "${CONDITION}" == "y" ] || [ "${CONDITION}" == "Y" ]; then
                        MONGO_VERSION=6.0; else echo "[Info] Exiting setup! - Aborted by ${USER}!"; exit 1;
                    fi
                fi
            fi
            curl -fsSL https://pgp.mongodb.com/server-${MONGO_VERSION}.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-${MONGO_VERSION}.gpg --dearmor
            echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-${MONGO_VERSION}.gpg ] https://repo.mongodb.org/apt/ubuntu ${OS_CODENAME}/mongodb-org/${MONGO_VERSION} multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list
        elif [ "${OS_ID,,}" == "debian" ]; then
            if [ "${MONGO_VERSION}" == "4.4" ] && [ "${OS_CODENAME}" == "bullseye" ]; then
                echo "[Exiting] MongoDB v${MONGO_VERSION} is Not available for ${OS_ID,,}-${OS_VERSION}."
                echo "[Info] v5.0, v6.0 is available for ${OS_ID,,}-${OS_VERSION}."
                echo "[Info] Please choose right version to complete the mongoDB installation."; exit 1;
            elif [ "${MONGO_VERSION}" == "6.0" ] && [ "${OS_CODENAME}" == "stretch" ]; then
                echo "[Info] MongoDB v${MONGO_VERSION} is Not available for ${OS_ID,,}-${OS_VERSION}."
                echo "[Info] v4.4, v5.0 is available for ${OS_ID,,}-${OS_VERSION}."
                echo "[Info] Please choose right version to complete the mongoDB installation."; exit 1;
            elif [ "${MONGO_VERSION}" == "5.0" ] && [ "${OS_CODENAME}" == "stretch" ]; then
                curl -fsSL https://pgp.mongodb.com/server-${MONGO_VERSION}.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-${MONGO_VERSION}.gpg --dearmor
                echo "deb http://repo.mongodb.org/apt/debian ${OS_CODENAME}/mongodb-org/${MONGO_VERSION} main" | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list
            else
                curl -fsSL https://pgp.mongodb.com/server-${MONGO_VERSION}.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-${MONGO_VERSION}.gpg --dearmor
                echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-${MONGO_VERSION}.gpg ] http://repo.mongodb.org/apt/debian ${OS_CODENAME}/mongodb-org/${MONGO_VERSION} main" | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list
            fi
        fi
        sudo apt-get update; sudo apt-get install -y mongodb-org
        sleep 5; START_MONGO_SERVICE;
    else
        echo "[Info] System detected 'Operating System' other than Ubuntu/Debian exiting..."; exit 1;
    fi
}
if dpkg -s mongodb-org >/dev/null 2>&1; then
    echo "====================================================================================="
    echo "[Info] MongoDB Already Present, to install newer version remove older version first."
    echo "====================================================================================="
else
    INSTALL_MONGO; if [ "$?" == "0" ]; then echo "";
    echo "====================================================================================="
    echo "* mongoDB - ${MONGO_VERSION} installed successfully."
    echo "* -----------------------------------------------------------------------------------"
    echo "* To check mongoDB service is running or not - run 'systemctl status mongod.service'"
    echo "* To debug and see the logs - cd /var/log/mongodb"
    echo "* To stop or restart the mongo service - 'systemctl stop mongod.service'"
    echo "* - 'systemctl restart mongod.service'"
    echo "====================================================================================="
    fi
fi
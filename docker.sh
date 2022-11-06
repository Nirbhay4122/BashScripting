#!/bin/bash

# uninstall old version of the docker
docker --version
if [[ $? -eq 0 ]]
then

    # ==================================Removing Docker daemon==========================================
    echo -e "\nRemoving the old docker package.\n"
    sudo apt-get remove docker docker-engine docker.io containerd runc
    
    if [[ $? -eq 0 ]]
    then
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
    fi

    echo -e "\nChecking the docker-compose is installed or not.\n"
    sleep 3
    which docker-compose
    echo -e "\nDocker-compose is instlled.\n"
    sleep 3

    # ==================================Removing Docker-compose==========================================
    echo -e "\nRemoving old Docker-compose.\n"
    sleep 3
    sudo apt-get remove docker-compose

    if [[ $? -eq 0 ]]
    then
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
    fi

else
    echo -e "\nDocker is not installed.\n"
fi

docker --version
if [[ $? -eq 0 ]]
then
    echo -e "\nOld version of the Docker is  not removed Kindly remove it mannually.\n"
    sleep 3
    exit 1
else
    echo -e "\nInstalliing New Version of the Docker & Docker-compose.\n"
    sleep 3

    # ============================================Updating System==========================================
    echo -e "\nUpdating System.\n"
    sudo apt-get update
    
    if [[ $? -eq 0 ]]
    then
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
    fi

    # ==========================================Basic Dependency===========================================
    echo -e "\nInstalling Basic dependency.\n"
    sleep 3
    sudo apt-get install ca-certificates curl gnupg lsb-release -y

    if [[ $? -eq 0 ]]
    then
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
    fi

    # ===========================================Adding Official GPG key======================================

    echo -e "\nAdding Keyring.\n"
    sleep 3
    sudo mkdir -p /etc/apt/keyrings

    if [[ $? -eq 0 ]]
    then
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
    fi

    echo -e "\nAdding Official GPG key-\n"
    sleep 3
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    if [[ $? -eq 0 ]]
    then
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
    fi

    echo -e "\nSetting up Docker Repository-\n"
    sleep
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    if [[ $? -eq 0 ]]
    then
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
    fi

    # =============================================Updating System================================================

    echo -e "\nUpdating System.\n"
    sleep 3
    sudo apt-get update
    if [[ $? -eq 0 ]]
    then
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        # ==============================If got GPG error===========================================================
        echo -e "\nFixing GPG Error.\n"
        sleep 3
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        sudo apt-get update

        if [[ $? -eq 0 ]]
        then
            echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
        else
            echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
        fi
    fi

    # ==========================================Installing Docker Latest Version=====================================

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    if [[ $? -eq 0 ]]
    then
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
    fi

    which docker
    if [[ $? -eq 0 ]]
    then
        echo -e "\nDocker is installed Successfully.\n"
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        echo -e "\nDocker is not installed properly.\n"
        echo -e "\nKindly install it Mannually Sorry."
        echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
    fi

    which docker-compose
    if [[ $? -eq 0 ]]
    then
        echo -e "\nDocker-compose is installed Successfully.\n"
        echo -e "\n[     STATUS: \e[1;32mSUCCESS \e[0m     ]\n"
    else
        echo -e "\nDocker-compose is not installed properly.\n"
        echo -e "\nKindly install it Mannually Sorry."
        echo -e "\n[     STATUS: \e[0;31mFAILED \e[0m     ]\n"
    fi

fi
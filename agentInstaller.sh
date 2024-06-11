#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

# Define variables
AGENT_VERSION="8.14.0"
DOWNLOAD_URL="https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-${AGENT_VERSION}-linux-x86_64.tar.gz"
TAR_FILE="elastic-agent-${AGENT_VERSION}-linux-x86_64.tar.gz"
EXTRACT_DIR="elastic-agent-${AGENT_VERSION}-linux-x86_64"
INSTALL_URL="https://e7e2c0e08ecf4a2baa34a1e73e41e223.fleet.us-east-2.aws.elastic-cloud.com:443"
ENROLLMENT_TOKEN="cTA5bThJOEJsRm9SS3d5NTNMdU46MEQ3emc3bkhRZVdyUVlYWFNwUVRRdw=="

# Download the Elastic Agent tarball
echo "Downloading Elastic Agent version ${AGENT_VERSION}..."
if curl -L -O ${DOWNLOAD_URL}; then
    echo "Download successful."
else
    echo "Download failed."
    exit 1
fi

# Extract the tarball
echo "Extracting ${TAR_FILE}..."
if tar xzvf ${TAR_FILE}; then
    echo "Extraction successful."
else
    echo "Extraction failed."
    exit 1
fi

# Change directory to the extracted folder
cd ${EXTRACT_DIR} || { echo "Directory ${EXTRACT_DIR} not found."; exit 1; }

# Install the Elastic Agent
echo "Installing Elastic Agent..."
if ./elastic-agent install --url=${INSTALL_URL} --enrollment-token=${ENROLLMENT_TOKEN} -n ; then
    echo "Elastic Agent installed successfully."
else
    echo "Elastic Agent installation failed."
    exit 1
fi

echo "Setup completed."


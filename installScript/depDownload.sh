#!/bin/bash
################################################################################

################################################################################
# install_ubuntu: Install all the dependencies in Ubuntu Server
################################################################################
function install_ubuntu() {
  echo "Installing dependencies. Please wait..."
  apt-get update > /dev/null 2>&1
  apt-get install -y parallel wget httpie > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    echo "Dependencies installed with success!"
  else
    echo "Dependencies weren't installed in your server"
    echo "Please check if you have internet connection and apt-get is"
    echo "working properly and try again."
    echo "Or you can try manually executing the command:"
    echo "apt-get update && apt-get install -y parallel wget httpie"
    exit $ERR_DEPNOTFOUND
  fi
}

################################################################################
# install_redhat: Install all the dependencies in Red Hat and CentOS
################################################################################
function install_redhat() {
  echo "Installing dependencies. Please wait..."
  yum install wget -y > /dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    echo "Failure - Can't install Wget"
    exit $ERR_NO_CONNECTION
  fi
  cat /etc/redhat-release | grep 6 > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    wget -O "/etc/yum.repos.d/tange.repo" $OLE_TANGE > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "Failure - Can't install Tange's repository for Parallel"
      exit $ERR_NO_CONNECTION
    fi
    yum install -y python-pip -y  > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "Failure - Can't install python-pip to download and install httpie"
      exit $ERR_NO_CONNECTION
    fi
    pip install httpie  > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "Failure - Can't install httpie"
      exit $ERR_NO_CONNECTION
    fi
  fi
  yum install -y epel-release  > /dev/null 2>&1
  yum install -y parallel httpie  > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    echo "Dependencies installed with success!"
  else
    echo "Dependencies wasn't installed in your server"
    echo "Please check if you have connection with the internet and yum is"
    echo "working and try again."
    echo "Or you can try manually executing the command:"
    echo "yum install -y epel-release && yum install -y parallel wget httpie"
    exit $ERR_DEPNOTFOUND
  fi
}

################################################################################
# remove_ubuntu: Remove all the dependencies in Ubuntu Server
################################################################################
function remove_ubuntu() {
  echo "Removing dependencies. Please wait..."
  apt-get --purge remove -y parallel wget httpie > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    echo "Dependencies removed with success!"
  else
    echo "Dependencies weren't removed in your server"
    echo "Please check if you have connection with the internet and apt-get is"
    echo "working and try again."
    echo "Or you can try manually executing the command:"
    echo "apt-get remove -y parallel wget httpie"
  fi
}

################################################################################
# remove_redhat: Install all the dependencies in Red Hat and CentOS
################################################################################
function remove_redhat() {
  echo "Removing dependencies. Please wait..."
  cat /etc/redhat-release | grep 6 > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    pip uninstall -y httpie > /dev/null 2>&1
  fi
  yum remove -y parallel wget httpie python-pip > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    echo "Dependencies removed with success!"
  else
    echo "Dependencies weren't removed in your server"
    echo "Please check if you have connection with the internet and yum is"
    echo "working and try again."
    echo "Or you can try manually executing the command:"
    echo "yum install -y epel-release && yum install -y parallel wget httpie"
  fi
}

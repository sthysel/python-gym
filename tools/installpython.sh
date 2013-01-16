#!/bin/bash

BREW_DEPENDENCIES="
curl
build-essential
libbz2-dev
libsqlite3-dev
zlib1g-dev
libxml2-dev
libxslt1-dev
libreadline-dev
libgdbm-dev
libgdb-dev
libxml2
libssl-dev
tk-dev
libgdbm-dev
libexpat1-dev
libncursesw5-dev
"

PYTHONS="2.6.8 2.7.2 3.3.0"
DEFAULT_PYTHON="2.6.8"
PYTHON_EXTRAS="virtualenv mercurial boto fabric"

is_root() {
    if [[ ${EUID} -ne 0 ]]
    then
       echo "$0 needs to be run as root."
       exit 1
    fi
}

install_deps() {
    echo "I need root access to install Python build dependencies"
    sudo  apt-get -y install ${BREW_DEPENDENCIES}
}

install_pythonbrew() {
    echo "Installing pythonbrew"
    curl -kL http://xrl.us/pythonbrewinstall | bash
}

install_pythons() {
    for p in ${PYTHONS}
    do
        pythonbrew install $p
    done
}

install_python_extras() {
    allpythons=$(pythonbrew list | awk -F "-" '{print $2}' | awk '{if ($1 != "") print $1}')
    for p in ${allpythons}
    do
        echo "Installing ${PYTHON_EXTRAS} for Python $p"
        pythonbrew switch $p
        pip install ${PYTHON_EXTRAS}
    done
}

install_deps
install_pythonbrew
install_pythons
install_python_extras

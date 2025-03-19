FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages and Firefox
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    xauth \
    x11-apps \
    openssh-server \
    wget \
    libgtk2.0-0 \
    libidn12 \
    libva-dev \
    libcurl4 \
    libasound2t64 \
    xdg-utils \
    libsqlite3-0 \    
    apt-utils \
    libwebkitgtk-6.0-4 \
    libxmu6 \
    libxpm4 \
    dbus-x11 \
    libspeexdsp1 && \
    # add-apt-repository ppa:mozillateam/ppa -y && \
    # apt-get update && \
    # apt-get install -y firefox && \
    install -d -m 0755 /etc/apt/keyrings && \
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null && \
    gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}' && \
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null && \
    printf 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000' | tee /etc/apt/preferences.d/mozilla > /dev/null && \
    apt-get update && apt-get install firefox -y && apt-get upgrade -y && \
    # Clean up
    apt-get purge -y software-properties-common && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    # apt-get install -y firefox apt-utils xdg-utils libwebkitgtk-6.0-4 libxmu6 libxpm4 dbus-x11 xauth libcurl4 openssh-server wget libgtk2.0-0 libidn12 libspeexdsp1 libva2 && \
    mkdir /var/run/sshd && \
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
    echo "AddressFamily inet" >> /etc/ssh/sshd_config && \
    sed -i '1iauth sufficient pam_permit.so' /etc/pam.d/sshd

RUN wget $(wget -O - https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html | sed -n 's/.*rel="\/\/\([a-z0-9_./]*icaclient_[0-9.]*_amd64.deb[^"]*\)".*/\1/p') -O /tmp/icaclient.deb
RUN dpkg -i /tmp/icaclient.deb && \
    apt-get -y -f install && \
    rm /tmp/icaclient.deb && \
    cd /opt/Citrix/ICAClient/keystore/cacerts/ && \
    ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/ && \
    c_rehash /opt/Citrix/ICAClient/keystore/cacerts/ 

RUN useradd -m -s /bin/bash workspace

USER workspace
WORKDIR /home/workspace
RUN mkdir -p .local/share/applications .config && \
    xdg-mime default wfica.desktop application/x-ica

USER root
CMD ["/usr/sbin/sshd", "-D"]

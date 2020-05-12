FROM ubuntu:18.04
LABEL maintainer="Manh Pham <phamducmanh1989@gmail.com>"

RUN apt-get update && apt-get -y install openssh-server supervisor
RUN mkdir /var/run/sshd
RUN echo 'root:123456' | chpasswd
RUN sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' \
    -e 's)#PubkeyAuthentication yes)RSAAuthentication yes\nPubkeyAuthentication yes\nAuthorizedKeysFile ~/.ssh/authorized_keys)' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD .ssh/id_rsa.pub /root/.ssh/
RUN cat ~/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
# Docker
RUN wget -qO- https://get.docker.com | sh
# zsh

RUN apt-get install -y git zsh && sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN rm /root/.zshrc && \
    ln -s /mnt/config/.zshrc /root/.zshrc && \
    ln -s /mnt/config/.zsh_history /root/.zsh_history && \
    ln -s /mnt/config/.cache /root/.cache
# Vscode
RUN ln -s /mnt/config/.vscode-server /root/.vscode-server
#

EXPOSE 22
VOLUME [ "/mnt/Source" ]
CMD ["/usr/bin/supervisord"]


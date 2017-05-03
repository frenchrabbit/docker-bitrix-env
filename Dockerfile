FROM centos:6

ENV SSH_PASS="bitrix"
ENV TIMEZONE="Europe/Moscow"

RUN echo 'extension=mysqli.so' > /etc/php.d/30-mysqli.ini
RUN curl http://repos.1c-bitrix.ru/yum/bitrix-env.sh > /tmp/bitrix-env.sh && \
    /bin/bash /tmp/bitrix-env.sh && \
    rm -f /tmp/bitrix-env.sh && \
    yum install -y openssh-server && \
    sed -i 's/MEMORY=$(free.*/MEMORY=$\{BVAT_MEM\:\=262144\}/g' /etc/init.d/bvat && \
    echo "bitrix:$SSH_PASS" | chpasswd && \
    cp -f /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    yum clean all

COPY run.sh /

CMD ["/bin/bash", "/run.sh"]

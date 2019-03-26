FROM centos:7

MAINTAINER Ricardo Arguello

RUN yum -y update && yum -y --setopt=tsflags=nodocs install httpd && yum clean all
RUN useradd -u 1001 -r -g 0 -s /sbin/nologin default
RUN sed -i \
    -e 's/^Listen 80/Listen 0.0.0.0:8080/' \
    -e 's/^User apache/User default/' \
    -e 's/^Group apache/Group root/' \
    -e 's%ErrorLog "logs/error_log"%ErrorLog "|/usr/bin/cat"%' \
    -e 's%CustomLog "logs/access_log"%CustomLog "|/usr/bin/cat"%' \
    /etc/httpd/conf/httpd.conf && \
    chmod -R a+rwx /etc/httpd/logs && \
    rm -rf /run/httpd && \
    mkdir /run/httpd && \
    chmod -R a+rwx /run/httpd

EXPOSE 8080

USER 1001

CMD /usr/sbin/apachectl -DFOREGROUND

FROM centos:7
MAINTAINER Ricardo Arguello

RUN yum -y update && \
    yum -y install httpd && \
    yum clean all

RUN useradd -u 1001 -r -g 0 -s /sbin/nologin default

RUN sed -i \
    -e 's/^Listen 80/Listen 0.0.0.0:8080/' \
    -e 's/^User apache/User default/' \
    -e 's/^Group apache/Group root/' \
    /etc/httpd/conf/httpd.conf && \
    chmod -R a+rwx /etc/httpd/logs && \
    chmod -R a+rwx /var/run/httpd &&    

# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

USER 1001

EXPOSE 8080

CMD ["/run-httpd.sh"]

FROM amazonlinux:2.0.20220719.0

RUN yum update -y && \
    yum install -y \
      procps \
      which \
      less \
      && \
    amazon-linux-extras install -y nginx1 && \
    yum clean all && \
    rm -rf /var/cache/yum/*

RUN ln -s /dev/stdout /var/log/nginx/access.log && \
    ln -s /dev/stderr /var/log/nginx/error.log

CMD ["nginx", "-g", "daemon off;"]

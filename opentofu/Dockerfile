FROM ubuntu:latest

ARG NAME
ENV project_name=$NAME

ARG VERSION
ENV github_version=$VERSION

LABEL maintainer ${project_name}

RUN apt update && apt -y install \ 
	ca-certificates \ 
	unzip \ 
	wget \ 
	ca-certificates \ 
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# Custom cache invalidation
ARG CACHEBUST=1

RUN set -x \
    && wget https://go.dev/dl/go1.21.6.linux-ppc64le.tar.gz \
    && tar -C /usr/local -xzf go1.21.6.linux-ppc64le.tar.gz 
    #&& export PATH=$PATH:/usr/local/go/bin

RUN set -x \
    && wget https://github.com/opentofu/opentofu/archive/refs/tags/v$github_version.zip \ 
    && unzip v$github_version.zip \ 
    && cd opentofu-$github_version \  
    && GOOS=linux GOARCH=ppc64le /usr/local/go/bin/go install ./cmd/tofu
    #&&  wget https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.1.zip \ 
    
RUN set -x \
        && mkdir -p /buildah \
        && mv /root/go/bin/* /buildah/$project_name-$github_version

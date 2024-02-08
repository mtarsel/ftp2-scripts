FROM ubuntu:20.04

ARG NAME
ENV project_name=$NAME

ARG VERSION
ENV github_version=$VERSION

LABEL maintainer ${project_name}

RUN apt update && apt -y install \ 
	build-essential \
	wget \ 
	openjdk-11-jdk \ 
	unzip \
	zip \
	python3 \
	ca-certificates \ 
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# Custom cache invalidation
#ARG CACHEBUST=1

RUN set -x \
	&& mkdir bazel-$github_version \
    	&& cd bazel-$github_version \
    	&& wget https://github.com/bazelbuild/bazel/releases/download/$github_version/bazel-$github_version-dist.zip \ 
	&& unzip bazel-$github_version-dist.zip \
	&& EXTRA_BAZEL_ARGS=--host_javabase=@local_jdk//:jdk ./compile.sh

RUN set -x \
	&& mkdir -p /buildah \
	&& mv /bazel-$github_version/output/* /buildah \
	&& mv /buildah/* /buildah/$project_name-$github_version

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
# based on: https://github.com/GoogleCloudPlatform/cloud-builders/blob/master/bazel/Dockerfile
RUN \
    apt-get update && \
    apt-get -y install \ 
        gnupg2 \
        python3.7-dev \
        python3.7-venv \
        python3.7-tk \
        curl \
        gcc \
        git \
        virtualenv \
        openjdk-8-jdk && \
    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && \
    apt-get -y install bazel && \
    apt-get -y upgrade bazel

ENTRYPOINT bash -c \
    bash install.sh && \
    bash -c "source dev_into.sh && \
    bazel build //... && \
    bazel test //... "

#    printf 'test --test_output=errors --action_env="GTEST_COLOR=1" \n # Force bazel output to use colors (good for jenkins) and print useful errors. \n common --color=yes \n build --action_env CC=/usr/bin/gcc-7 --cxxopt="-std=c++14"\n' > .bazelrc && \

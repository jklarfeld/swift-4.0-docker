FROM ubuntu:16.04
MAINTAINER Jeffrey Klarfeld <jklarfeld@me.com>

# Install Some Packages
RUN 	apt-get -q update && \
    	apt-get -q install -y \
	make \
	libc6-dev \
	clang-3.8 \
	curl \
	libedit-dev \
	python2.7 \
	python2.7-dev \
	libicu-dev \
	libssl-dev \
	libxml2 \
	git \
	libcurl4-openssl-dev \
	pkg-config \
	&& update-alternatives --quiet --install /usr/bin/clang clang /usr/bin/clang-3.8 100 \
	&& update-alternatives --quiet --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100 \
	&& rm -r /var/lib/apt/lists/*

ARG SWIFT_PLATFORM=ubuntu16.04
ARG SWIFT_BRANCH=development
ARG SWIFT_VERSION=swift-DEVELOPMENT-SNAPSHOT-2017-07-13-a

ENV SWIFT_PLATFORM=$SWIFT_PLATFORM \
    SWIFT_BRANCH=$SWIFT_BRANCH \
    SWIFT_VERSION=$SWIFT_VERSION

RUN SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM.tar.gz \
    && curl -fSsL $SWIFT_URL -o swift.tar.gz \
    && curl -fSsL $SWIFT_URL.sig -o swift.tar.gz.sig \
    && export GNUPGHOME="$(mktemp -d)" \
    && set -e; \
       for key in \
       	   7463A81A4B2EEA1B551FFBCFD441C977412B37AD \
	   1BE1E29A084CB305F397D62A9F597F4D21A56D5F \
	   A3BAFD3556A59079C06894BD63BC1CFE91D306C6 \
       ; do \
       	 gpg --quiet --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
       done \
    && gpg --batch --verify --quiet swift.tar.gz.sig swift.tar.gz \
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && rm -r "$GNUPGHOME" swift.tar.gz.sig swift.tar.gz

RUN swift --version


# https://swift.org/builds/development/ubuntu1604/swift-DEVELOPMENT-SNAPSHOT-2017-07-13-a/swift-DEVELOPMENT-SNAPSHOT-2017-07-13-a-ubuntu16.04.tar.gz

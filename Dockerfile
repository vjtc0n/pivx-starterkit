FROM ubuntu:artful

LABEL maintainer="vjtc0n12345@gmail.com"
# switch to root, let the entrypoint drop back to configured user
USER root
ENV USER pivx
ARG VERSION
ARG BDBVERSION

RUN apt-get update && apt-get install -y software-properties-common \
  && apt-add-repository ppa:bitcoin/bitcoin \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  automake \
  bsdmainutils \
  git \
  gnupg2 \
  libboost-all-dev \
  libdb4.8-dev \
  libdb4.8++-dev \
  libevent-dev \
  libssl-dev \
  libtool \
  pkg-config \
  wget \
  autotools-dev \
  autoconf \
  libminiupnpc-dev

# dependencies for qt-gui
RUN apt-get install -y --no-install-recommends \
  libqrencode-dev \
  libqt5gui5 \
  libqt5core5a \
  libqt5dbus5 \
  protobuf-compiler \
  qttools5-dev \
  qttools5-dev-tools \
  libprotobuf-dev

WORKDIR /tmp

#install su-exec
RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

# add user to the system
RUN useradd -d /home/"${USER}" -s /bin/sh -G users "${USER}"

# download source
RUN wget -O /tmp/pivx-"${VERSION}".tar.gz "https://github.com/PIVX-Project/PIVX/releases/download/v"${VERSION}"/pivx-"${VERSION}".tar.gz" \
  && wget -O /tmp/SHA256SUMS.asc "https://github.com/PIVX-Project/PIVX/releases/download/v"${VERSION}"/SHA256SUMS.asc"

# verify sha hash
ADD https://raw.githubusercontent.com/f-u-z-z-l-e/docker-coin-scripts/master/verify-sha256.sh /tmp/
RUN chmod +x verify-sha256.sh && ./verify-sha256.sh SHA256SUMS.asc pivx-"${VERSION}".tar.gz

# verify gpg signature
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 3BDCDA2D87A881D9
RUN gpg --keyserver-options auto-key-retrieve --verify SHA256SUMS.asc
# gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
# RUN gpg --keyserver-options auto-key-retrieve --verify rvm-installer.asc 

# compile binaries
RUN mkdir pivx && tar xf pivx-"${VERSION}".tar.gz -C pivx --strip-components 1 \
  && mkdir -p /tmp/pivx/db4 \
  && wget "http://download.oracle.com/berkeley-db/db-${BDBVERSION}.tar.gz" \
  && echo "12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-${BDBVERSION}.tar.gz" | sha256sum -c \
  && tar -xzvf db-"${BDBVERSION}".tar.gz \
  && cd db-"${BDBVERSION}"/build_unix \
  && ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/tmp/pivx/db4 \
  && make install \
  && cd /tmp/pivx \
  && ./autogen.sh \
  && ./configure LDFLAGS="-L/tmp/pivx/db4/lib/" CPPFLAGS="-I/tmp/pivx/db4/include/" \
  && make -j1 \
  && make install \
  && cd ~ \
  && rm -rf /tmp/pivx

EXPOSE 51470

WORKDIR /home/"${USER}"

# add startup scripts
ADD ./scripts /usr/local/bin
ENTRYPOINT ["entrypoint.sh"]
CMD ["start-network.sh"]

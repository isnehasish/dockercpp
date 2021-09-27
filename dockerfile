FROM ubuntu:latest
WORKDIR /install

# The cpp base cooied from the other laptop
RUN apt update -y && apt upgrade -y && apt-get install sudo -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y wget curl zip unzip vim tar build-essential \
    autoconf libtool pkg-config \
    libcurl4-openssl-dev libssl-dev git uuid-dev zlib1g-dev libpulse-dev cmake lsb-release

# Installaing prometheus-cpp and civetweb
RUN cd /install && git clone https://github.com/jupp0r/prometheus-cpp.git && cd prometheus-cpp && \
    git submodule init && git submodule update && mkdir _build && cd _build && \
    cmake .. -DBUILD_SHARED_LIBS=ON -DENABLE_PUSH=OFF -DENABLE_COMPRESSION=OFF && cmake --build . --parallel 4 && \
    cmake --install . && cp -r /install/prometheus-cpp/3rdparty/civetweb /install/civetweb && cd /install/civetweb && \
    make clean slib WITH_LUA=1 WITH_WEBSOCKET=1 && cp -L lib* /usr/lib/. && cp include/* /usr/include/. && cd src && \
    g++ -c -o civetserver.o CivetServer.cpp -lcivetweb -fPIC && g++ -shared -o libcivetserver.so civetserver.o && \
    mv libcivetserver.so /usr/lib/.

# Copying prometheus-cpp and civetweb examples
RUN mkdir -p /install/examples/prometheus && cp -rL /install/prometheus-cpp/cmake/project-import-cmake/* /install/examples/prometheus/. && \
    mkdir -p /install/examples/civetweb && cp /install/civetweb/examples/embedded_cpp/* /install/examples/civetweb/. 

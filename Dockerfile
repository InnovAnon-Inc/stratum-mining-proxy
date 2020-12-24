FROM ubuntu:16.04 as base
MAINTAINER Michael Twomey, mick@twomeylee.name

RUN apt update          \
 && apt full-upgrade -y \
 && apt install      -y \
      ca-certificates   \
      python2.7         \
      python-pip

FROM base as builder
RUN apt install -y  \
    build-essential \
    python2.7-dev
RUN python2 -m pip install -U --no-cache-dir pip
RUN python2 -m pip install -U --no-cache-dir setuptools wheel
RUN python2 -m pip install -U --no-cache-dir distribute argparse twisted
WORKDIR /app
COPY . ./
RUN python2 -m pip install    --no-cache-dir lib/stratum-0.2.15.tar.gz
RUN cd midstatec && make -j$(nproc)
RUN python2 setup.py bdist_wheel
RUN python2 -m pip install    --no-cache-dir .

#FROM base as app
#WORKDIR /app
#COPY --from=builder /usr/local/lib/python2.7/dist-packages /usr/local/lib/python2.7/
RUN apt autoremove    \
 && apt remove -y     \
      build-essential \
      python2.7-dev   \
      python-pip      \
 && apt clean         \
 && rm -rf /var/cache/apt/*

EXPOSE 3333
EXPOSE 8332
ENTRYPOINT ["/usr/bin/env", "python2", "/app/mining_proxy.py"]
CMD        ["--help"]
#CMD        ["-o", "scrypt.na.mine.zergpool.com", "-p", "3433", "-cu", "FHqqd3DbyQr7NX7rdDKhYmXKYoPTfjUuZh", "-cp", "c=FLO"]
CMD        ["-o", "yescrypt.na.mine.zergpool.com", "-p", "6233", "-cu", "FHqqd3DbyQr7NX7rdDKhYmXKYoPTfjUuZh", "-cp", "c=FLO"]


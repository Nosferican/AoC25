FROM ubuntu:24.04
ENV TZ America/New_York
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV JULIA_VERSION 1.12.2
ENV JULIA_NUM_THREADS 4
ENV QUARTO_VERSION 1.8.26

RUN apt-get update \
    && apt-get install -y wget \
    && apt-get install -y unzip \
    && apt-get install -y git \
    && apt-get install -y gnupg2
RUN cd /usr/local/bin && \
    mkdir dvc_dir && \
    cd dvc_dir && \
    wget https://dvc.org/deb/dvc.list -O /etc/apt/sources.list.d/dvc.list && \
    wget -qO - https://dvc.org/deb/iterative.asc | tee /etc/apt/trusted.gpg.d/iterative.asc && \
    apt-get update && \
    apt-get install -y dvc \
    && dvc --version
RUN cd /usr/local/bin \
    && mkdir quarto_dir \
    && cd quarto_dir \
    && wget -q https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && echo "60451a42095dd60bc23ad529b39ca81017da688aab029bec9b5565818fc55cf8  quarto-${QUARTO_VERSION}-linux-amd64.deb" | sha256sum -c - \
    && apt-get install -y ./quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && quarto add --no-prompt kapsner/authors-block
RUN cd /usr/local/bin \
    && mkdir julia_dir \
    && cd julia_dir \
    && wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && echo "a6d0c39ea57303ebcffa7a8d453429b86eb271e150c7cb0f5958fe65909b493a  julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - \
    && tar fxz julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && rm -R julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && cd .. \
    && ln -s julia_dir/julia-${JULIA_VERSION}/bin/julia julia
RUN julia -e 'using Pkg; Pkg.add(["Revise", "IJulia"]); using IJulia; IJulia.installkernel("julia");'
RUN mkdir -p ~/.julia/config/ && echo "using Revise" >> ~/.julia/config/startup.jl
RUN bash

################# BASE IMAGE ######################
FROM --platform=linux/amd64 ubuntu:24.04 as base

################## METADATA ######################
LABEL base_image="ubuntu:24.04"
LABEL version="0.1"
LABEL software="Trim Galore"
LABEL software.version="0.6.10"
LABEL about.summary="Trim Galore! is a wrapper script to automate quality and adapter trimming as well as quality control, with some added functionality to remove biased methylation positions for RRBS sequence files (for directional, non-directional (or paired-end) sequencing). Trim Galore is a a Perl wrapper around two tools: Cutadapt and FastQC. To use, ensure that these two pieces of software are available and copy the trim_galore script to a location available on the PATH."
LABEL about.home="https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/"
LABEL about.documentation="https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/"
LABEL about.license_file="https://github.com/FelixKrueger/TrimGalore/blob/master/LICENSE"
LABEL about.license="GPL-3.0"

################## MAINTAINER ######################
MAINTAINER Matthew Galbraith <matthew.galbraith@cuanschutz.edu>

################## INSTALLATION ######################
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGES wget unzip default-jre libfindbin-libs-perl pipx python3-venv pigz

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and extract FastQC
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip && \
	unzip fastqc_v0.12.1.zip && \
    chmod +x FastQC/fastqc && \
    ln -s /FastQC/fastqc /usr/local/bin/fastqc

# Download and extract Trim Galore
RUN wget https://github.com/FelixKrueger/TrimGalore/archive/0.6.10.tar.gz -O trim_galore_v0.6.10.tar.gz && \
    tar xvzf trim_galore_v0.6.10.tar.gz && \
    chmod +x TrimGalore-0.6.10/trim_galore && \
    ln -s /TrimGalore-0.6.10/trim_galore /usr/local/bin/trim_galore

# Install Cutadapt using pipx
RUN pipx install cutadapt==5.1 && \
    # pipx ensurepath # does not seem to work here
    ln -s /root/.local/bin/cutadapt /usr/local/bin/cutadapt

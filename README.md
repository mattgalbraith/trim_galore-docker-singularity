[![Docker Image CI](https://github.com/mattgalbraith/trim_galore-docker-singularity/actions/workflows/docker-image.yml/badge.svg)](https://github.com/mattgalbraith/trim_galore-docker-singularity/actions/workflows/docker-image.yml)

# trim_galore-docker-singularity

## Build Docker container for Trim Galore and (optionally) convert to Apptainer/Singularity.  

Trim Galore! is a wrapper script to automate quality and adapter trimming as well as quality control, with some added functionality to remove biased methylation positions for RRBS sequence files (for directional, non-directional (or paired-end) sequencing). Trim Galore is a a Perl wrapper around two tools: Cutadapt and FastQC. To use, ensure that these two pieces of software are available and copy the trim_galore script to a location available on the PATH.  
  
#### Requirements:
Python3
pigz (for parallel decompression)
Perl
JRE (for FastQC)
[Cutadapt](https://cutadapt.readthedocs.io/en/stable/index.html)
[FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
  
## Build docker container:  

### 1. For TOOL installation instructions:  
https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/  
https://github.com/FelixKrueger/TrimGalore

### 2. Build the Docker Image

#### To build image from the command line:  
``` bash
# Assumes current working directory is the top-level <tool>-docker-singularity directory
docker build -t trim_galore:0.6.10 . # tag should match software version
```
* Can do this on [Google shell](https://shell.cloud.google.com)

#### To test this tool from the command line:
``` bash
# Check that cutadapt is installed
docker run --rm -it trim_galore:0.6.10 cutadapt --version
# Check that FastQC is installed
docker run --rm -it trim_galore:0.6.10 fastqc -v
# Test run Trim Galore
docker run --rm -it trim_galore:0.6.10 trim_galore --cores 4
```

## Optional: Conversion of Docker image to Singularity  

### 3. Build a Docker image to run Singularity  
(skip if this image is already on your system)  
https://github.com/mattgalbraith/singularity-docker

### 4. Save Docker image as tar and convert to sif (using singularity run from Docker container)  
``` bash
docker images
docker save <Image_ID> -o toolVersion-docker.tar && gzip toolVersion-docker.tar # = IMAGE_ID of <tool> image
docker run -v "$PWD":/data --rm -it singularity:1.1.5 bash -c "singularity build /data/toolVersion.sif docker-archive:///data/toolVersion-docker.tar.gz"
```
NB: On Apple M1/M2 machines ensure Singularity image is built with x86_64 architecture or sif may get built with arm64  

Next, transfer the <tool>.sif file to the system on which you want to run <tool> from the Singularity container  

### 5. Test singularity container on (HPC) system with Singularity/Apptainer available  
``` bash
# set up path to the Singularity container
TOOL_SIF=path/to/toolVersion.sif

# Test that <tool> can run from Singularity container
singularity run $TOOL_SIF tool --help # depending on system/version, singularity may be called apptainer
```
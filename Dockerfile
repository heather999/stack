FROM lsstsqre/centos:7-stack-lsst_distrib-w_2019_19
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG LSST_STACK_DIR=/opt/lsst/software/stack

ARG LSST_USER=lsst
ARG LSST_GROUP=lsst

WORKDIR $LSST_STACK_DIR

RUN echo "Environment: \n" && env | sort && \
    echo "Executing: eups distrib install obs_lsst" && \
    source scl_source enable devtoolset-6 && \
    gcc --version && \
    echo -e "source scl_source enable devtoolset-6\n$(cat loadLSST.bash)" > loadLSST.bash && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \
                  export EUPS_PKGROOT=https://eups.lsst.codes/stack/src; \
                  setup lsst_distrib; \
                  git clone https://github.com/lsst/obs_lsst; \
                  cd obs_lsst; \
                  git checkout dc2/run2.1; \
                  setup -r . -j; \
                  scons;' 

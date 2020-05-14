FROM lsstsqre/centos:7-stack-lsst_distrib-v19_0_0
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG DESC_OBS_LSST_VER=19.0.0-run2.2-v2

ARG LSST_STACK_DIR=/opt/lsst/software/stack

ARG LSST_USER=lsst
ARG LSST_GROUP=lsst

WORKDIR $LSST_STACK_DIR

# pip freeze > $LSST_STACK_DIR/require.txt; \
#                  sed -i 's/astropy==3.1.2/astropy==3.2.3/g' $LSST_STACK_DIR/require.txt; \
#                  pip install -c $LSST_STACK_DIR/require.txt astropy==3.2.3; \

RUN echo "Environment: \n" && env | sort && \
    echo "Executing: eups distrib install obs_lsst" && \
    source scl_source enable devtoolset-8 && \
    gcc --version && \
    echo -e "source scl_source enable devtoolset-8\n$(cat loadLSST.bash)" > loadLSST.bash && \
    /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \
                  export EUPS_PKGROOT=https://eups.lsst.codes/stack/src; \
                  setup lsst_distrib; \
                  curl -LO https://github.com/lsst/obs_lsst/archive/$DESC_OBS_LSST_VER.tar.gz; \
                  tar xvfz $DESC_OBS_LSST_VER.tar.gz; \ 
                  ln -s obs_lsst-$DESC_OBS_LSST_VER obs_lsst; \
                  cd obs_lsst; \
                  setup -r . -j; \
                  scons;' 

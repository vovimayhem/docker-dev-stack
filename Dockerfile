# NOTE: Currently starting off at 753.8 MB
FROM vovimayhem/dev-stack:base
MAINTAINER Roberto Quintanilla <roberto.quintanilla@gmail.com>

################################################################################
# 1.1: Install MRI Rubies:

# Available MRI Rubies:
# - Current stable: Ruby 2.2.0
# - Previous stable: Ruby 2.1.5
# - Old stable (2.0.0 series): Ruby
# - Old stable (1.9.3 series): Ruby 1.9.3-p551
ENV MRI_RUBIES 2.2.0 2.1.5 2.0.0-p598 1.9.3-p551

# TODO: Remove the ruby install vía APT, as I can't find exactly where it is
# needed in order to build the required rubies...
RUN apt-get update && apt-get install -y ruby --no-install-recommends && \
echo "\033[1;34mBuilding Interpreters: MRI Ruby" && RUBY_ENGINE=ruby && \
echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc" && \
for RUBY_VERSION in $MRI_RUBIES; \
do \
  RUBY_MAJOR=`echo $RUBY_VERSION | cut -d'.' -f 1,2` \
  && RUBY_ROOT=/opt/rubies/$RUBY_ENGINE-$RUBY_VERSION \
  && echo "\033[0;34m - Fetching & building $RUBY_ENGINE $RUBY_MAJOR ($RUBY_VERSION) into $RUBY_ROOT:" \
  && mkdir -p /tmp/src/$RUBY_ENGINE-$RUBY_VERSION \
  && curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
  | tar -xjC /tmp/src/$RUBY_ENGINE-$RUBY_VERSION --strip-components=1 \
  && cd /tmp/src/$RUBY_ENGINE-$RUBY_VERSION \
  && autoconf \
  && ./configure --prefix="$RUBY_ROOT"  --enable-shared --disable-install-doc \
                                        --enable-dtrace CFLAGS="-O3" \
  && make -j"$(nproc)" \
  && make install \
  && PATH=$RUBY_ROOT/bin:$ORIGINAL_PATH \
  && gem install bundler \
  && rm -rf /tmp/src/$RUBY_ENGINE-$RUBY_VERSION \
  && echo "\033[0;34m - Finished building $RUBY_ENGINE $RUBY_MAJOR ($RUBY_VERSION) into $RUBY_ROOT!" ; \
done \
&& apt-get purge -y --auto-remove ruby && rm -rf /var/lib/apt/lists/*

################################################################################
# 1.2: Install Rubinius:
#  - These are slow (9m52.017s for 2.4.1 on my machine)
#  - And huge! (154M for 2.4.1)
#  - That's why only the latest rubinius is going to be built (for now)
ENV RBX_RUBIES 2.4.1

RUN export LC_ALL=C.UTF-8 && export LANG=C.UTF-8 \
  && echo "\033[1;34mBuilding Interpreters: Rubinius Ruby" \
  && RUBY_ENGINE=rbx \
  && RUBY_ROOT=/opt/rubies/ruby-2.2.0 \
  && PATH=$RUBY_ROOT/bin:$ORIGINAL_PATH \
  && mkdir -p /tmp/src \
  && for RUBY_VERSION in $RBX_RUBIES; \
  do \
    RUBY_MAJOR=`echo $RUBY_VERSION | cut -d'.' -f 1,2` \
    && RBX_ROOT=/opt/rubies/$RUBY_ENGINE-$RUBY_VERSION \
    && echo "\033[0;34m - Fetching & building $RUBY_ENGINE $RUBY_MAJOR ($RUBY_VERSION) into $RBX_ROOT:" \
    && mkdir -p /tmp/src/$RUBY_ENGINE-$RUBY_VERSION \
    && git clone --depth 1 --branch v$RBX_RUBIES \
       https://github.com/rubinius/rubinius.git /tmp/src/$RUBY_ENGINE-$RUBY_VERSION \
    && cd /tmp/src/$RUBY_ENGINE-$RUBY_VERSION \
    && bundle \
    && SHELL="/bin/bash" ./configure --prefix=$RBX_ROOT \
    && rake install \
    && rm -rf /tmp/src/$RUBY_ENGINE-$RUBY_VERSION \
    && echo "\033[0;34m - Finished building $RUBY_ENGINE $RUBY_MAJOR ($RUBY_VERSION) into $RBX_ROOT!" ; \
  done

################################################################################
# 2: Install NodeJS:
ENV NODE_VERSION 0.10.34
RUN echo "\033[1;34mBuilding Interpreters: NodeJS" \
  && mkdir -p /tmp/src/node-v$NODE_VERSION \
  && export NODE_ROOT=/opt/nodejs/v$NODE_VERSION \
  && echo "\033[0;34m - Fetching & building NodeJS $NODE_VERSION into $NODE_ROOT:" \
  && curl -SL "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz" \
    | tar -xzC /tmp/src/node-v$NODE_VERSION --strip-components=1 \
  && cd /tmp/src/node-v$NODE_VERSION \
  && ./configure --prefix=$NODE_ROOT --with-dtrace \
  && make -j"$(nproc)"                      \
  && make install                           \
  && rm -rf /tmp/src/node-v$NODE_VERSION

################################################################################

USER app
WORKDIR /app

# Currently finishing off at 864.2 MB
CMD ["/bin/bash"]

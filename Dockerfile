# NOTE: Currently starting off at 752.9 MB
FROM vovimayhem/dev-stack:base
MAINTAINER Roberto Quintanilla <roberto.quintanilla@gmail.com>

ENV ORIGINAL_PATH $PATH

################################################################################
# 1.1: Install MRI Rubies:

# Available MRI Rubies:
# - Current stable: Ruby 2.2.0
# - Previous stable: Ruby 2.1.5
# - Old stable (2.0.0 series): Ruby
# - Old stable (1.9.3 series): Ruby 1.9.3-p551
ENV MRI_RUBIES 2.2.0 2.1.5 2.0.0-p598 1.9.3-p551

RUN apt-get update && apt-get install -y ruby --no-install-recommends && \
echo "Build Language Interpreters: MRI Ruby:" && RUBY_ENGINE=ruby && \
echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc" && \
for RUBY_VERSION in $MRI_RUBIES; \
do \
  RUBY_MAJOR=`echo $RUBY_VERSION | cut -d'.' -f 1,2` \
  && RUBY_ROOT=/opt/rubies/$RUBY_ENGINE-$RUBY_VERSION \
  && echo "# Fetching & building $RUBY_ENGINE $RUBY_MAJOR ($RUBY_VERSION) to $RUBY_ROOT:" \
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
  && rm -rf /tmp/src/$RUBY_ENGINE-$RUBY_VERSION ; \
done \
&& apt-get purge -y --auto-remove ruby && rm -rf /var/lib/apt/lists/*

################################################################################
# 2: Install NodeJS:
ENV NODE_VERSION 0.10.34
RUN mkdir -p /tmp/src/nodejs \
  && curl -SL "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz" \
    | tar -xzC /tmp/src/nodejs --strip-components=1 \
  && cd /tmp/src/nodejs \
  && ./configure --prefix="/usr" --with-dtrace \
  && make -j"$(nproc)"                      \
  && make install                           \
  && rm -rf /tmp/src/nodejs

################################################################################

USER app
WORKDIR /app

CMD ["/bin/bash"]

# Currently finishing off at 863.3 MB

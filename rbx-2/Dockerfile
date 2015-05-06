# The following image is heavily influenced by the docker-library official ruby
# image (You can see the original source at https://github.com/docker-library/ruby).
#
# However, There are some key differences:
#
#  - Creates an 'app' user & group, in order to run the application with
#  unprivileged mode.
#
#  - Sets the home in the '/app' folder, where the application code is expected
#  to be, pretty much the way Heroku organizes a container's directory layout.
#
#  - Builds Ruby with dtrace enabled, making this image ideal for development
#  environments. Please note that because of this, these images are not
#  necessarily optimal for production environments.
#
#  - Sets the GEM_HOME directory to the '/app/vendor/bundle' folder, so gems
#  can be inspected by the developer & provided by mounting the app in the
#  volume.
#
FROM buildpack-deps:jessie
MAINTAINER Roberto Quintanilla <roberto.quintanilla@gmail.com>

################################################################################
# 1: The 'app' User & '/app' directory.

# Add the "app" user and group first to make sure their IDs get assigned
# consistently - we definitely like them to be both 1000, to match our
# workstation's user/group ID's.
# Also, we like the app user home directory to be '/app':
RUN cp /etc/default/useradd /etc/default/useradd.bak \
  && echo "HOME=" >> /etc/default/useradd \
  && useradd --create-home --shell /usr/sbin/nologin app \
  && rm -rf /etc/default/useradd \
  && mv /etc/default/useradd.bak /etc/default/useradd \
  && rm /app/.bash_logout /app/.bashrc /app/.profile

# Define the '/app' directory as a volume, to prevent persistance of files in
# this folder:
VOLUME /app

################################################################################
# 2: Building ruby
# - Taken almost entirely from https://github.com/docker-library/ruby

ENV RBX_VERSION 2.5.3
ENV RBX_RELEASE_SHA1 c4323b9410a12e45c1c9da4a17607bd57ec1bb59

# Set UTF-8 locale (Won't build unless these locales are set like this):
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# The rubinius build script is written entirely in ruby. We'll purge this later
# in this RUN command to make sure our final image uses what we just built.
#
# Please note that unlike the official ruby image, we're enabling DTrace:
RUN apt-get update \
	&& apt-get install -y bison bundler libedit-dev libgdbm-dev llvm-dev ruby systemtap-sdt-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/src/ruby \
	&& curl -fSL -o ruby.tar.bz2 "https://github.com/rubinius/rubinius/releases/download/v$RBX_VERSION/rubinius-$RBX_VERSION.tar.bz2" \
	&& echo "$RBX_RELEASE_SHA1 *ruby.tar.bz2" | sha1sum -c - \
	&& tar -xjf ruby.tar.bz2 -C /usr/src/ruby --strip-components=1 \
	&& rm ruby.tar.bz2 \
	&& cd /usr/src/ruby \
	&& bundle \
	&& SHELL="/bin/bash" ./configure --prefix=/usr/local \
	&& rake install \
	&& SUDO_FORCE_REMOVE=yes apt-get purge -y --auto-remove bison bundler libedit-dev libgdbm-dev llvm-dev ruby systemtap-sdt-dev \
	&& rm -r /usr/src/ruby

# TODO: Fix the prefix path on the previous step!
ENV PATH /usr/local/rubinius/gems/bin:/usr/local/rubinius/bin:$PATH

# Unlike the official ruby image, creating the "$HOME/.gemrc" won't help us when
# running the app as an unprivileged user.

# Bundler is already installed with Rubinius.

# Also, the official ruby image's GEM_HOME + bundler configuration won't help us
# make available for inspection and/or mountability the installed gems inside
# the '/app/vendor/bundle' folder.

################################################################################
# 3: Install Node
#
# We'll include the current version of Node, as Javascript Interpreter:
#  - For asset precompilation: Some if not most of ruby development will involve
#  compiling javascript for web frontends (jQuery, Turbolinks, angular, ember, etc)

ENV NODE_VERSION 0.12.2
ENV NPM_VERSION 2.9.0

# verify gpg and sha256: http://nodejs.org/dist/v0.10.30/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN gpg --keyserver pool.sks-keyservers.net \
  --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D \
  114F43EE0176B71C7BC219DD50A3051F888C628D

RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm cache clear

################################################################################
# 4: Final Setup
#
# Here we'll prepare the image to run as the unprivileged 'app' user, and
# configure the system, gems & bundler to add the '/app/vendor/bundle' to their
# lookup paths.

# Set the '/app/vendor/bundle' folder as the GEM_HOME - It will preserve
# the original gem paths - check it with 'gem env':
ENV GEM_HOME /app/vendor/bundle

# Don't create ".bundle" in our app
ENV BUNDLE_APP_CONFIG $GEM_HOME

# Add the the app's bin path and the app bundler's bin path to the $PATH
# environment variable, so any gem and app executables can be found by the
# system:
ENV PATH /app/bin:/app/vendor/bundle/bin:$PATH

# Set the image user as the unprivileged 'app' user:
USER app

# Set the image's working directory to the '/app' folder, which is the 'app'
# user's home:
WORKDIR /app

CMD ["irb"]

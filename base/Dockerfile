# NOTE: Currently starting off at 154.7 MB
FROM debian:jessie
MAINTAINER Roberto Quintanilla <roberto.quintanilla@gmail.com>

################################################################################
# 1: Add the "app" user and group first to make sure their IDs get assigned
# consistently - we definitely like them to be both 1000, to match our
# workstation's user/group ID's.
# Also, we like the app user home directory to be '/app':
RUN cp /etc/default/useradd /etc/default/useradd.bak \
  && echo "HOME=" >> /etc/default/useradd \
  && useradd --create-home --shell /usr/sbin/nologin app \
  && rm -rf /etc/default/useradd \
  && mv /etc/default/useradd.bak /etc/default/useradd \
  && rm /app/.bash_logout /app/.bashrc /app/.profile

# NOTE: Currently starting off at 155 MB
################################################################################
# 2: Install "runtime" and "build" dependencies stage.
#
# Pre-Build Dependencies (12.7 MB):
# - curl: Used to fetch repo keys, the MySQL Config repository, and interpreter code
# - ca-certificates: Used by curl to fetch from secure URLs
#
# Runtime & Build Dependencies (428 MB):
#
# Runtime: Dependencies needed for running common applications:
# - systemtap-sdt-dev: Installs dtrace
# Build:
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y curl ca-certificates --no-install-recommends \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
  && curl -SL 'https://www.postgresql.org/media/keys/ACCC4CF8.asc' | apt-key add - \
  && mkdir -p /tmp/packages \
  && curl -SL 'http://dev.mysql.com/get/mysql-apt-config_0.3.2-1debian7_all.deb' -o /tmp/packages/mysql-apt-config.deb \
  && DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/packages/mysql-apt-config.deb \
  && rm -rf /tmp/packages/mysql-apt-config.deb \
  && runtimeDeps="imagemagick libc6 libevent-2.0-5 libevent-core-2.0-5 libevent-extra-2.0-5 libevent-openssl-2.0-5 libevent-pthreads-2.0-5 libffi6 libreadline6 libssl1.0.0 llvm openssl procps systemtap-sdt-dev" \
  && appRuntimeDeps="libyaml-0-2 mysql-client postgresql-client sqlite3" \
  && buildDeps="autoconf bison bzip2 gcc git libc6-dev libbz2-dev libcurl4-openssl-dev libevent-dev libglib2.0-dev libjpeg-dev libmagickcore-dev libmagickwand-dev libxml2-dev libxslt-dev llvm-dev make tar wget" \
  && rubyBuildDeps="patch isomd5sum libffi-dev libgdbm-dev libncurses-dev libreadline-dev libssl-dev libyaml-dev zlib1g-dev" \
  && nodeBuildDeps="g++ python" \
  && appBuildDeps="libyaml-dev libsqlite3-dev libmysqlclient-dev libpq-dev" \
  && DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y $runtimeDeps $appRuntimeDeps \
    $buildDeps $rubyBuildDeps $nodeBuildDeps $appBuildDeps \
    --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/pgdg.list

# NOTE: Currently ending off at 752.9 MB

#
# #USER app
# #WORKDIR /app
# #CMD ["/bin/bash"]

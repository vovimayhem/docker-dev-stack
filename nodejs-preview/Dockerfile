FROM vovimayhem/dev-stack-base
MAINTAINER Roberto Quintanilla <roberto.quintanilla@gmail.com>

# We'll specify the NodeJS Stable Version:
ENV NODE_VERSION 0.11.14

# We'll specify the NodeJS root dir, into which we'll build the selected NodeJS:
ENV NODE_ROOT /opt/nodejs/v$NODE_VERSION

# Run the goddamn build script!
USER root
RUN build-language-support

# We'll add the Node binaries to $PATH:
ENV PATH $NODE_ROOT/bin:$PATH

USER app

CMD ["node"]

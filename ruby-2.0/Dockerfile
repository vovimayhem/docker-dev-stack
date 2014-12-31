# NOTE: Currently starting off at 753.8 MB
FROM vovimayhem/dev-stack-base-nodejs:stable
MAINTAINER Roberto Quintanilla <roberto.quintanilla@gmail.com>

# We'll specify the ruby engine - MRI:
ENV RUBY_ENGINE ruby

# We'll specify the MRI version:
ENV RUBY_VERSION 2.0.0-p598

# For whatever reason we'll need the Major version:
ENV RUBY_MAJOR 2.0

# We'll specify the ruby root dir, into which we'll build the selected ruby:
ENV RUBY_ROOT /opt/rubies/$RUBY_ENGINE-$RUBY_VERSION

# Run the goddamn build script!
USER root
RUN build-language-support

# We'll add the ruby binaries path to $PATH:
ENV PATH $RUBY_ROOT/bin:$ORIGINAL_PATH

USER app

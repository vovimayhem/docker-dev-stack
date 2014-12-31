# NOTE: Currently starting off at 753.8 MB
FROM vovimayhem/dev-stack:ruby-2.2
MAINTAINER Roberto Quintanilla <roberto.quintanilla@gmail.com>

# We'll specify the ruby engine - MRI:
ENV RUBY_ENGINE rbx

# We'll specify the Rubinius version:
ENV RUBY_VERSION 2.4.1




# We'll specify the ruby root dir, into which we'll build the selected ruby:
ENV RUBY_ROOT /opt/rubies/$RUBY_ENGINE-$RUBY_VERSION

# Run the goddamn build script! (and erase the ruby we use for building)
USER root
RUN build-language-support && rm -rf /opt/rubies/ruby-2.2.0

# We'll add the ruby binaries path to $PATH:
ENV PATH $RUBY_ROOT/bin:$ORIGINAL_PATH

USER app

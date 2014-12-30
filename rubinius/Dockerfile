# NOTE: Currently starting off at 864.2 MB
FROM vovimayhem/dev-stack:latest
MAINTAINER Roberto Quintanilla <roberto.quintanilla@gmail.com>

ENV RUBY_ENGINE rbx
ENV RUBY_MAJOR 2.4
ENV RUBY_VERSION 2.4.1
ENV RUBY_ROOT /opt/rubies/$RUBY_ENGINE-$RUBY_VERSION
ENV PATH $RUBY_ROOT/bin:$ORIGINAL_PATH

USER app

CMD ["/bin/bash"]

# NOTE: Currently starting off at 753.8 MB
FROM vovimayhem/dev-stack-base-ruby
MAINTAINER Roberto Quintanilla <roberto.quintanilla@gmail.com>

################################################################################
# When someone builds from this Docker container:
# 1: Will copy whatever it is in the builder's folder:
ONBUILD COPY . /app

# 2: OMG the folder is owned by root! Change folder ownership to app:
# ...and while we are here, let's remove anything git from the app folder:
ONBUILD USER root
ONBUILD RUN chown -R app:app /app && rm -rf /app/.git*
ONBUILD USER app

# 3: Set the gem home to the /app/vendor/bundle folder:
ONBUILD ENV GEM_HOME /app/vendor/bundle

# 4: Add the bundle folder binaries to the PATH:
ONBUILD ENV PATH $GEM_HOME/bin:$PATH

# 5: Of course! Create the /app/vendor/bundle folder (if it does not exist),
# and configure bundler to take this path:
ONBUILD RUN mkdir -p /app/vendor/bundle && rm -rf /app/vendor/bundle/* && \
bundle config --global path "$GEM_HOME" && \
bundle config --global bin "$GEM_HOME/bin"

# 6: Lastly, run bundle install:
ONBUILD RUN bundle install
################################################################################

CMD ["irb"]

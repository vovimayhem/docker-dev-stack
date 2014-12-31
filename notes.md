# Ruby post-build Gem dirs:
 - ruby 2.2.0:      /opt/rubies/ruby-2.2.0/lib/ruby/gems/2.2.0
 - ruby 2.1.5:      /opt/rubies/ruby-2.1.5/lib/ruby/gems/2.1.0
 - ruby 2.0.0-p598: /opt/rubies/ruby-2.0.0-p598/lib/ruby/gems/2.0.0
 - ruby-1.9.3-p551: /opt/rubies/ruby-1.9.3-p551/lib/ruby/gems/1.9.1

# Building all the shit together:
time sh -c "echo 'Right away sir' && \
docker build --rm -t vovimayhem/dev-stack-base        dev-stack-base && \
docker build --rm -t vovimayhem/dev-stack-base-nodejs dev-stack-base-nodejs && \
docker build --rm -t vovimayhem/dev-stack-base-ruby   dev-stack-base-ruby && \
docker build --rm -t vovimayhem/dev-stack:ruby-1.9    dev-stack/ruby-1.9 && \
docker build --rm -t vovimayhem/dev-stack:ruby-2.0    dev-stack/ruby-2.0 && \
docker build --rm -t vovimayhem/dev-stack:ruby-2.1    dev-stack/ruby-2.1 && \
docker build --rm -t vovimayhem/dev-stack:ruby-2.2    dev-stack/ruby-2.2 && \
docker build --rm -t vovimayhem/dev-stack:rbx-2.4     dev-stack/rbx-2.4"


# Building just what I need to run some ol' fashioned testing:
time sh -c "echo 'Right away sir' && \
docker build --rm -t vovimayhem/dev-stack-base dev-stack-base && \
docker build --rm -t vovimayhem/dev-stack-base-nodejs dev-stack-base-nodejs && \
docker build --rm -t vovimayhem/dev-stack-base-ruby dev-stack-base-ruby && \
docker build --rm -t vovimayhem/dev-stack:ruby-2.2 dev-stack/ruby-2.2"

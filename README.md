# Vovimayhem's Development Stack for Docker

This is a Docker container with several programming languages and interpreters.

My goal is to provide an easy way to get things started for developers
at the projects I work at.

(Right now we are using mainly a Vagrant project with a big LXC container,
provisioned with ansible, which makes trivial things like updating ruby
versions über painful...)

## Split docker images

So! We're splitting the docker containers... after a while it's painfully SLOW
to build each and every language this container supports... and we end up with a
HUGE container.

This is the new strategy:

### Working with Ruby?

Pull any of the following containers from Docker Hub:

- MRI 2.2 (2.2.0):        `docker pull vovimayhem/dev-stack:ruby-2.2`
- MRI 2.1 (2.1.5):        `docker pull vovimayhem/dev-stack:ruby-2.1`
- MRI 2.0 (2.0.0-p598):   `docker pull vovimayhem/dev-stack:ruby-2.0`
- MRI 1.9 (1.9.3-p551):   `docker pull vovimayhem/dev-stack:ruby-1.9`
- Rubinius (2.4.1):       `docker pull vovimayhem/dev-stack:rbx-2.4`
- JRuby:                  `docker pull vovimayhem/dev-stack:jruby`

Ruby containers will include NodeJS *Stable*, because most likely you'll be
developing a Ruby-On-Rails app, and you'll deffinitely need a Javascript runtime
for the asset compiling. You can remove NodeJS if your'e not doing so.

If your'e asking to include NodeJS *Preview*, most likely you're looking to
develop a NodeJS project with the newest of the newest NodeJS code, within your
rails app. The best practice is for you to work on a new project that builds
upon the vovimayhem/dev-stack:nodejs-preview container instead - see the next
section.

### Working with NodeJS?

Pull any of the following containers:

- NodeJS Stable (v0.10.34): `docker pull vovimayhem/dev-stack:nodejs-stable`
- NodeJS Preview (v0.11.14): `docker pull vovimayhem/dev-stack:nodejs-preview`

### Working with Java

Really??? You'd better pull my other Docker project:

`docker pull vovimayhem/java` (I'll make a java tag later on, with the 'app' user)

## Language Support:

### C and those guys:

  As a pre-requisite for building rubies and nodejs, compilers and interpreters
  for C and all that stuff must be present in the container.

  So it's fairly safe to say that yeah, the C Brothers are supported.

### Ruby:

- Matz Ruby Interpreter (The most commonly used):
  - 2.2.0
  - 2.1.5
  - 2.0.0 (patch level 598)
  - 1.9.3 (patch level 551)
- Rubinius
  - 2.4.1
- JRuby coming soon - along with Java

### Javascript

- NodeJS:
  - 0.10.34

## Alpha release notes (or I'm in such a big hurry right now)

Consider this Docker container as an "Alpha" release (as I do).

I'm still figuring out a few kinks - like where would it be cool to have a
gem path for the 'app' user, or even some gem permission errors.

I'll tackle these up as soon as I finish integrating Rubinius, I promise!

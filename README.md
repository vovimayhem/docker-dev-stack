# Vovimayhem's Development Stack for Docker

This is a Docker container with several programming languages and interpreters.

My goal is to provide an easy way to get things started for developers
at the projects I work at.

(Right now we are using mainly a Vagrant project with a big LXC container,
provisioned with ansible, which makes trivial things like updating ruby
versions über painful...)

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
    - 2.4.1 - This is the only version, their installs are SLOW and HUGE!
  - JRuby coming soon - along with Java

### Javascript

  - NodeJS:
    - 0.10.34

## Alpha release notes (or I'm in such a big hurry right now)

Consider this Docker container as an "Alpha" release (as I do).

I'm still figuring out a few kinks - like where would it be cool to have a
gem path for the 'app' user, or even some gem permission errors.

I'll tackle these up as soon as I finish integrating Rubinius, I promise!

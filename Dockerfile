FROM nanobox/runit

# Create directories
RUN mkdir -p \
  /var/log/gonano \
  /var/nanobox \
  /opt/nanobox/hooks

# Install and rsync
RUN apt-get update -qq && \
    apt-get install -y rsync && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# Download mist
RUN curl \
      -f \
      -k \
      -o /usr/local/bin/mist \
      https://s3.amazonaws.com/tools.nanopack.io/mist/linux/amd64/mist && \
    chmod 755 /usr/local/bin/mist

# Download md5 (used to perform updates in hooks)
RUN curl \
      -f \
      -k \
      -o /var/nanobox/mist.md5 \
      https://s3.amazonaws.com/tools.nanopack.io/mist/linux/amd64/mist.md5

# Install hooks
RUN curl \
      -f \
      -k \
      https://s3.amazonaws.com/tools.nanobox.io/hooks/mist-stable.tgz \
        | tar -xz -C /opt/nanobox/hooks

# Download hooks md5 (used to perform updates)
RUN curl \
      -f \
      -k \
      -o /var/nanobox/hooks.md5 \
      https://s3.amazonaws.com/tools.nanobox.io/hooks/mist-stable.md5

# Run runit automatically
CMD [ "/opt/gonano/bin/nanoinit" ]

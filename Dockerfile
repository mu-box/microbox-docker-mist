FROM mubox/base

# Create directories
RUN mkdir -p \
  /var/log/gomicro \
  /var/microbox \
  /opt/microbox/hooks

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
      https://s3.amazonaws.com/tools.microbox.cloud/mist/linux/amd64/mist && \
    chmod 755 /usr/local/bin/mist

# Download md5 (used to perform updates in hooks)
RUN curl \
      -f \
      -k \
      -o /var/microbox/mist.md5 \
      https://s3.amazonaws.com/tools.microbox.cloud/mist/linux/amd64/mist.md5

# Install hooks
RUN curl \
      -f \
      -k \
      https://s3.amazonaws.com/tools.microbox.cloud/hooks/mist-stable.tgz \
        | tar -xz -C /opt/microbox/hooks

# Download hooks md5 (used to perform updates)
RUN curl \
      -f \
      -k \
      -o /var/microbox/hooks.md5 \
      https://s3.amazonaws.com/tools.microbox.cloud/hooks/mist-stable.md5

WORKDIR /data

# Run runit automatically
CMD [ "/opt/gomicro/bin/microinit" ]

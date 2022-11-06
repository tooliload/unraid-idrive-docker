# build:
#  docker build -t baroka/idrive .

FROM ubuntu:latest

RUN mkdir -p /home/backup

WORKDIR /work

# Copy entrypoint script
COPY entrypoint.sh .
RUN chmod a+x entrypoint.sh

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends vim unzip curl libfile-spec-native-perl && \
    rm -rf /var/lib/apt/lists
RUN apt-get update && apt-get install -y --no-install-recommends build-essential sqlite3 perl-doc libdbi-perl libdbd-sqlite3-perl && \
    rm -rf /var/lib/apt/lists
RUN cpan install common::sense
RUN cpan install Linux::Inotify2

# Timezone (no prompt)
ARG TZ "Europe/Madrid"
ENV tz=$TZ
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
RUN echo "$tz" > /etc/timezone
RUN rm -f /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# Delete
RUN rm -rf /var/lib/apt/lists

# Install IDrive
RUN curl -O https://www.idrivedownloads.com/downloads/linux/download-for-linux/LinuxScripts/IDriveForLinux.zip && \
    unzip IDriveForLinux.zip

RUN rm IDriveForLinux.zip

WORKDIR /work/IDriveForLinux/scripts

# Give execution rights
RUN chmod a+x *.pl

# Create the log file to be able to run tail
RUN touch /var/log/idrive.log

# Run the command on container startup
ENTRYPOINT ["/work/entrypoint.sh"]
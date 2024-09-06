FROM ghcr.io/dfinity/icp-dev-env-azle:3

# Set the environment variable to avoid the prompt for the installation
ENV DFXVM_INIT_YES=true

RUN apt update \
&& apt install -y curl \
&& curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
&& apt install -y nodejs socat \
&& sh -ci "$(curl -fsSL https://sdk.dfinity.org/install.sh)" \
&& curl https://sh.rustup.rs -sSf | bash -s -- -y

WORKDIR /app

COPY . .
RUN npm install \
  && npm install -D reflect-metadata

RUN chmod +x ./postCreate.sh
RUN /bin/sh -c ./postCreate.sh

RUN chmod +x ./deploy-local-ledger.sh
RUN chmod +x ./service.sh

RUN chmod +x ./entry.sh
ENTRYPOINT ["/bin/sh", "-c", "./entry.sh"]

# Expose the port 4944 instead of 4943 because of the port forwading
EXPOSE 4943 4944

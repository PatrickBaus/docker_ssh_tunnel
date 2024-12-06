FROM alpine:3.21.0
LABEL maintainer="Patrick Baus <patrick.baus@physik.tu-darmstadt.de>"
LABEL description="SSH Tunnel"

ARG WORKER_USER_ID=5557

# Upgrade installed packages,
# add a user called `worker`
# and install the SSH client
RUN apk --no-cache upgrade && \
    addgroup -g ${WORKER_USER_ID} worker && \
    adduser -D -u ${WORKER_USER_ID} -G worker worker && \
    apk --no-cache add openssh-client

USER worker

CMD \
  echo "Starting SSH tunnel to ${ENDPOINT}" && \
  ssh \
  -NT \
  -4 \
  -o StrictHostKeyChecking=accept-new \
  -o ServerAliveInterval=${KEEP_ALIVE_INTERVAL=1} \
  -o ServerAliveCountMax=3 \
  -o ExitOnForwardFailure=yes \
  -i /run/secrets/ssh_key \
  -L *:${LOCAL_PORT=${REMOTE_PORT}}:${REMOTE_HOST}:${REMOTE_PORT} \
  -p ${SSH_PORT=22} \
  ${USER}@${ENDPOINT}

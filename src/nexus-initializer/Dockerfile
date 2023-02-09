FROM alpine:3.17.1
RUN apk update \
    && apk add -q \
    curl \
    jq \
    bash

COPY /configure_nexus.sh /

CMD ["bash", "configure_nexus.sh"]
FROM php:7.4
ENV PORT=8080
ENV PORT_TWO=8081

WORKDIR /app

COPY . .
RUN chmod 755 docker-entrypoint.sh

EXPOSE ${PORT}
EXPOSE ${PORT_TWO}

ENTRYPOINT ["sh","docker-entrypoint.sh"]
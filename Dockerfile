FROM ruby:2.7.5-alpine

ENV APP_HOME=/app \
    TZ=UTC

RUN apk add autoconf \
            automake \
            gcc \
            git \
            g++ \
            libtool \
            make \
            musl-dev \
            postgresql14-dev \
    && addgroup -g 1000 -S app \
    && adduser -S -h ${APP_HOME} -s /sbin/nologin -G app -u 1000 app

WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock $APP_HOME/

RUN gem update bundler \
    && bundle install --jobs=$(nproc) --system --binstubs=/usr/local/bin \
    && chown -R app:app $APP_HOME

USER app

COPY --chown=app:app . $APP_HOME

EXPOSE 3000

COPY --chown=app:app config/docker/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "--config", "config/puma.rb"]

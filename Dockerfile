FROM ruby:2.7.5-alpine

ENV APP_HOME=/druzhba_rails \
    TZ=UTC

COPY Gemfile Gemfile.lock $APP_HOME/

WORKDIR $APP_HOME

RUN set -x \
    && addgroup -g 1000 -S app \
    && adduser -S -h ${APP_HOME} -s /sbin/nologin -G app -u 1000 app \
    && apk add --no-cache --virtual .build-deps \
            autoconf \
            automake \
            gcc \
            git \
            g++ \
            libtool \
            make \
            musl-dev \
    && apk add --no-cache \
            postgresql14-dev \
            tzdata \
    && gem update bundler \
    && bundle install --jobs=$(nproc) --system --binstubs=/usr/local/bin \
    && chown -R app:app $APP_HOME \
    && apk del .build-deps            

COPY --chown=app:app . $APP_HOME

USER app

EXPOSE 3000

COPY --chown=app:app config/docker/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "--config", "config/puma.rb"]

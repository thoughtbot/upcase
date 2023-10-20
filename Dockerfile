# syntax=docker/dockerfile:1
ARG BASE_IMAGE=ruby
ARG BASE_TAG=3.0.6-slim
ARG BASE=${BASE_IMAGE}:${BASE_TAG}

FROM ${BASE} as builder

ENV LANG en_us.UTF-8

RUN apt-get update -qq \
  && apt-get install -y \
  build-essential \
  ca-certificates \
  curl \
  git \
  shared-mime-info \
  libpq-dev \
  && curl -sL https://deb.nodesource.com/setup_18.x | bash \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" \
  > /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /app

ARG RAILS_ROOT=/app
WORKDIR $RAILS_ROOT

COPY Gemfile* $RAILS_ROOT
RUN gem install bundler \
  && bundle config --global frozen 1 \
  && bundle install --without development test \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . $RAILS_ROOT

RUN yarn install --check-files

# The SECRET_KEY_BASE here isn't used. Precompiling assets doesn't use your
# secret key, but Rails will fail to initialize if it isn't set.
RUN NODE_ENV=production \
  RAILS_ENV=production \
  PRECOMPILE=true \
  SECRET_KEY_BASE=no \
  RAILS_SERVE_STATIC_FILES=true \
  REDIS_URL=redis://localhost:6379 \
  APP_DOMAIN=thoughtbot.com/upcase \
  bundle exec rake assets:precompile

RUN rm -rf tmp/cache spec

FROM ${BASE}

ENV LANG en_US.UTF-8

RUN apt-get update -qq \
  && apt-get install -y libjemalloc2 tzdata curl git zip unzip shared-mime-info libpq-dev \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash \
  && apt-get update -qq \
  && apt-get install -y nodejs  \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 app && \
  useradd --uid 1000 --no-log-init --create-home --gid app app
USER app

COPY --from=builder --chown=app:app /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder --chown=app:app /app /app

ENV NODE_ENV=production
ENV RACK_ENV=production
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
ENV PORT 3000
ENV SECRET_KEY_BASE no

ARG RAILS_ROOT=/app/

WORKDIR $RAILS_ROOT

ARG PORT=3000

CMD bundle exec puma -p $PORT -C ./config/puma.rb
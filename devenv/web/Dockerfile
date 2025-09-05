ARG IMAGE_FILE=ruby

FROM ${IMAGE_FILE}:3.4.5-alpine3.21
RUN apk --no-cache add \
    build-base \
    bash \
    file \
    make \
    curl \
    gcompat \
    gcc \
    g++ \
    git \
    zlib-dev \
    libffi-dev \
    readline-dev \
    libxml2-dev \
    libxslt-dev \
    nodejs \
    postgresql-dev \
    postgresql-client \
    nodejs \
    npm \
    imagemagick  \
    tzdata \
    yaml \
    yaml-dev
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV APP_PATH /work/app
WORKDIR $APP_PATH

# Gemfileを先にコピーしてbundle installを実行
COPY Gemfile $APP_PATH
COPY Gemfile.lock $APP_PATH
RUN gem update bundler \
    && bundle config set force_ruby_platform true \
    && bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

# その後でアプリケーションコードをコピー
COPY . $APP_PATH

CMD ["bin/rails", "s"]

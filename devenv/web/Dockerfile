# ビルド用コンテナ
ARG IMAGE_FILE
FROM $IMAGE_FILE:3.3.6-alpine3.20 AS builder
RUN apk --no-cache add --virtual build-dependencies \
    build-base \
    git \
    make \
    gcc \
    g++ \
    gcompat \
    zlib-dev \
    libffi-dev \
    readline-dev \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev
RUN apk --no-cache add \
    bash \
    postgresql-client \
    imagemagick \
    tzdata
ENV APP_PATH /work/app
WORKDIR $APP_PATH

COPY Gemfile $APP_PATH
#COPY Gemfile.lock $APP_PATH
RUN gem update bundler \
    && bundle config set force_ruby_platform true \
    && bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3 \
    && apk del build-dependencies # --virtual でグルーピングしたpackageを削除
RUN rm -rf /usr/local/bundle/cache/*

# mainコンテナ
#    ${BROWSER} \

FROM ${IMAGE_FILE}:3.3.6-alpine3.20
RUN apk --no-cache add \
    build-base \
    bash \
    file \
    make \
    curl \
    gcompat \
    gcc \
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
    tzdata
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV APP_PATH /work/app
WORKDIR $APP_PATH
COPY . $APP_PATH
COPY --from=builder /usr/local/bundle /usr/local/bundle

CMD ["bin/rails", "s"]

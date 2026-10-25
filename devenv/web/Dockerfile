ARG IMAGE_FILE=ruby

FROM ${IMAGE_FILE}:4.0.8-alpine3.23
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

# alpine の nodejs パッケージには corepack が含まれないため npm で入れる。
# pnpm のバージョンは package.json の packageManager フィールドに従わせる
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN npm install -g corepack \
    && corepack enable pnpm

ENV APP_PATH /work/app
WORKDIR $APP_PATH

# packageManager で指定された pnpm をイメージ内のキャッシュに取得しておく
COPY package.json $APP_PATH
RUN corepack install

# Gemfileを先にコピーしてbundle installを実行
COPY Gemfile $APP_PATH
COPY Gemfile.lock $APP_PATH
RUN gem update bundler \
    && bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

# その後でアプリケーションコードをコピー
COPY . $APP_PATH

CMD ["bin/rails", "s"]

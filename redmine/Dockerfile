FROM redmine:6.1.0

COPY config/configuration.yml config

RUN set -eux; \
        \
        apt-get update && apt-get install -y --no-install-recommends \
                antiword \
                catdoc \
                catdvi \
                djview \
                djview3 \
                gcc \
                gzip \
                libemail-outlook-message-perl \
                libwpd-tools \
                libwps-tools \
                libxapian-dev \
                make \
                poppler-utils \
                ruby-xapian \
                uuid \
                uuid-dev \
                unrtf \
                unzip \
                xapian-omega \
                xpdf \
                xz-utils \
        ; \
        \
# install plugins
        gosu redmine git clone --depth 1 https://github.com/redmica/redmica_ui_extension.git plugins/redmica_ui_extension; \
        gosu redmine git clone --depth 1 https://github.com/mikitex70/redmine_drawio.git plugins/redmine_drawio; \
        \
# install gems
        gosu redmine bundle install;

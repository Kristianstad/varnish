# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_REPO=${SaM_REPO:-ghcr.io/kristianstad/secure_and_minimal}
ARG ALPINE_VERSION=${ALPINE_VERSION:-3.23}
ARG APP_VERSION=${APP_VERSION:-7.7.3}
ARG IMAGETYPE="application"
ARG COREUTILS_VERSION="9.11"
ARG CONTENTIMAGE1="ghcr.io/kristianstad/sam-content:coreutils-$COREUTILS_VERSION"
ARG CONTENTSOURCE1="/content-app/usr/bin/rm"
ARG CONTENTDESTINATION1="/tmp/finalfs/bin/"
ARG CLONEGITS="https://github.com/mattiasgeniar/varnish-6.0-configuration-templates.git"
ARG RUNDEPS="varnish dropbear-ssh"
ARG MAKEDIRS="/var/lib/varnish"
ARG STARTUPEXECUTABLES="/usr/sbin/varnishd /usr/bin/gcc /usr/bin/cc"
ARG EXECUTABLES="/bin/rm /usr/bin/dbclient /usr/bin/ssh /usr/bin/varnishhist /usr/bin/varnishtest /usr/bin/varnishtop /usr/bin/varnishlog /usr/bin/varnishadm /usr/bin/varnishstat /usr/bin/varnishncsa"
ARG BUILDCMDS=\
"   cd varnish-6.0-configuration-templates "\
'&& cp default.vcl "$DESTDIR/" '\
'&& gzip "$DESTDIR/default.vcl"'
ARG FINALCMDS="ln -s /usr/lib /usr/libexec /usr/local/"
ARG LINUXUSEROWNEDRECURSIVE="/var/lib/varnish"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} AS content1
FROM ${CONTENTIMAGE2:-scratch} AS content2
FROM ${CONTENTIMAGE3:-scratch} AS content3
FROM ${CONTENTIMAGE4:-scratch} AS content4
FROM ${CONTENTIMAGE5:-scratch} AS content5
FROM ${BASEIMAGE:-$SaM_REPO:base-${ALPINE_VERSION}} AS base
FROM ${INITIMAGE:-scratch} AS init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-$SaM_REPO:build-${ALPINE_VERSION}} AS build
FROM ${BASEIMAGE:-$SaM_REPO:base-${ALPINE_VERSION}} AS final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
# Re-declare ARGs
ARG ALPINE_VERSION
ARG APP_VERSION

RUN chown 0:0 /var/lib/varnish

ENV VAR_CONFIG_DIR="/etc/varnish" \
    VAR_PID_FILE="/run/varnishd.pid" \
    VAR_JAIL="none" \
    VAR_VCL_FILE='$VAR_CONFIG_DIR/default.vcl' \
    VAR_READ_ONLY_PARAMS="cc_command,vcc_allow_inline_c,vmod_path" \
    VAR_LISTEN_ADDRESS="" \
    VAR_LISTEN_PORT="6081" \
    VAR_MANAGEMENT_ADDRESS="localhost" \
    VAR_MANAGEMENT_PORT="6082" \
    VAR_STORAGE="malloc,100M" \
    VAR_DEFAULT_TTL="120" \
    VAR_ADDITIONAL_OPTS="" \
    VAR_LINUX_USER="varnish" \
    VAR_SSH_ADDRESS="0.0.0.0" \
    VAR_SSH_PORT="2222" \
    VAR_SSH_AUTHORIZED_KEYS="" \
    VAR_KEEP_CAPS="cap_ipc_lock" \
    VAR_FINAL_COMMAND='varnishd -j $VAR_JAIL -P "$VAR_PID_FILE" -f "$VAR_VCL_FILE" -r $VAR_READ_ONLY_PARAMS -a $VAR_LISTEN_ADDRESS:$VAR_LISTEN_PORT -T $VAR_MANAGEMENT_ADDRESS:$VAR_MANAGEMENT_PORT -s $VAR_STORAGE -t $VAR_DEFAULT_TTL -F $VAR_ADDITIONAL_OPTS'

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>

LABEL org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.title="varnish" \
      org.opencontainers.image.description="Varnish ${APP_VERSION} based on secure_and_minimal ${ALPINE_VERSION}"

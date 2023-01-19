# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_REPO=${SaM_REPO:-ghcr.io/kristianstad/secure_and_minimal}
ARG ALPINE_VERSION=${ALPINE_VERSION:-3.17}
ARG IMAGETYPE="application"
ARG COREUTILS_VERSION="9.1"
ARG CONTENTIMAGE1="ghcr.io/kristianstad/sam-content:coreutils-$COREUTILS_VERSION"
ARG CONTENTSOURCE1="/content-app/usr/bin/rm"
ARG CONTENTDESTINATION1="/tmp/finalfs/bin/"
ARG CLONEGITS="https://github.com/mattiasgeniar/varnish-6.0-configuration-templates.git"
ARG RUNDEPS="varnish dropbear-ssh"
ARG MAKEDIRS="/var/lib/varnish"
ARG STARTUPEXECUTABLES="/usr/sbin/varnishd /usr/bin/gcc"
ARG EXECUTABLES="/bin/rm /usr/bin/ssh /usr/bin/dbclient /usr/bin/varnishhist /usr/bin/varnishtest /usr/bin/varnishtop /usr/bin/varnishlog /usr/bin/varnishadm /usr/bin/varnishstat /usr/bin/varnishncsa"
ARG BUILDCMDS=\
"   cd varnish-6.0-configuration-templates "\
'&& cp default.vcl "$DESTDIR/" '\
'&& gzip "$DESTDIR/default.vcl"'
ARG FINALCMDS="ln -s /usr/lib /usr/libexec /usr/local/"
ARG LINUXUSEROWNEDRECURSIVE="/var/lib/varnish"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${BASEIMAGE:-$SaM_REPO:base-$ALPINE_VERSION} as base
FROM ${INITIMAGE:-scratch} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-$SaM_REPO:build-$ALPINE_VERSION} as build
FROM ${BASEIMAGE:-$SaM_REPO:base-$ALPINE_VERSION} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================

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
    VAR_INIT_CAPS="cap_chown" \
    VAR_FINAL_COMMAND='varnishd -j $VAR_JAIL -P "$VAR_PID_FILE" -f "$VAR_VCL_FILE" -r $VAR_READ_ONLY_PARAMS -a $VAR_LISTEN_ADDRESS:$VAR_LISTEN_PORT -T $VAR_MANAGEMENT_ADDRESS:$VAR_MANAGEMENT_PORT -s $VAR_STORAGE -t $VAR_DEFAULT_TTL -F $VAR_ADDITIONAL_OPTS'

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>

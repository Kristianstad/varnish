# varnish
A Secure and Minimal docker-image with Varnish. Listens by default on port 6081.

## Environment variables
### pre-set variables (can be set at runtime)
* VAR_JAIL (none)
* VAR_VCL_FILE (/etc/varnish/default.vcl)
* VAR_READ_ONLY_PARAMS (cc_command,vcc_allow_inline_c,vmod_path)
* VAR_LISTEN_ADDRESS ("")
* VAR_LISTEN_PORT (6081)
* VAR_MANAGEMENT_ADDRESS (localhost)
* VAR_MANAGEMENT_PORT (6082)
* VAR_STORAGE (malloc,100M)
* VAR_DEFAULT_TTL (120)
* VAR_ADDITIONAL_OPTS ("") f ex. "-p tcp_fastopen=on -S /etc/varnish/secret"

### Optional runtime variables
* VAR_IMPORTS: #-separated list of imports.
* VAR_BACKENDS: semicolon-separated (;) list of backend names.
* VAR_&lt;backend&gt;: #-separated list of backend definition rows for &lt;backend&gt;.
* VAR_ACLS: #-separated list of acl names.
* VAR_&lt;acl&gt;: #-separated list of acl definition rows for &lt;acl&gt;.
* VAR_VCL_INIT, VAR_VCL_RECV, VAR_VCL_PIPE, VAR_VCL_PASS, VAR_VCL_HASH, VAR_VCL_HIT, VAR_VCL_MISS, VAR_VCL_BACKEND_RESPONSE, VAR_VCL_BACKEND_ERROR, VAR_VCL_DELIVER, VAR_VCL_PURGE, VAR_VCL_SYNTH, VAR_VCL_FINI: #-separated list of sub definition rows. F ex VAR_VCL_RECV='set req.http.Host = regsub(req.http.Host, ":[0-9]+", "");# return (pass);'.

## Capabilities
### Can drop
* All but CHOWN, SETPCAP, SETGID and SETUID.

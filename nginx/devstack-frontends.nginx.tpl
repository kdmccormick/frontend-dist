# nginx configuration file for serving edX microfrontends on Devstack.
# This configuration is intended for development environments on localhost.
# This should not be deployed to a production environment as-is.

server {

    # Catch-all hostname.
    server_name _;

    # Use relative redirects (no hostname+port part of URL).
    # This stops nginx from clobbering the port number.
    absolute_redirect off;

    # Serve files relative to /var/www/html.
    root /var/www/html/;

    # Declare the index page.
    index index.html;

    # Host frontend redirects will be injected after this line.
    #HOST_FRONTEND_REDIRECTS

    # rewrite ^/account(/(.*))?$ http://localhost:1997/$2 redirect;

    # Add trailing slashes to all URLs that do not contain a question mark
    # (for query params) or dot (for file names).
    rewrite ^([^.\?]*[^/])$ $1/ redirect;

    # For frontend paths (i.e., all paths other than the root),
    # try to serve the file it is referencing ($uri).
    # If that file doesn't exist, serve the index.html of the frontend that the
    # path is prefixed with, letting the React app handle the rest of the routing.
    location ~ ^/(?<frontend>[\w.\-]+).*$ {
        try_files $uri /$frontend/index.html =404;
    }
}

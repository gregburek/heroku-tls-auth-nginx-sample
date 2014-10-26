# heroku-force-ssl-sample

Configuring your Heroku app so that it will redirect insecure HTTP traffic to an
HTTPS endpoint can be finicky and is language/framework specific.

The [nginx buildpack](https://github.com/ryandotsmith/nginx-buildpack) gives us
a broadly applicable and language angnostic way to redirect HTTP app traffic to
a secure HTTPS address.

By adding:

```
if ($http_x_forwarded_proto != 'https') {
  rewrite ^ https://$host$request_uri? permanent;
}
```

to the `location` section of your app's nginx config file template, any access
to that location will be met with a `301 Moved Permanently` redirect to the
`https` version of that site and path.

As all apps are accessible at `https://<app-name>.herokuapp.com/` by using
Heroku's `herokuapp.com` SSL cert, this provides a free and easy way to secure
your apps. Custom domain names require custom SSL certs, which are available
from traditional SSL vendors or from Heroku addon [Expedited
SSL](https://www.expeditedssl.com/)

## Try it out on Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/gregburek/heroku-force-ssl-sample)


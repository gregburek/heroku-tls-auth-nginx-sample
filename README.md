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


## Manual set up

```bash
> git clone https://github.com/gregburek/heroku-force-ssl-sample
> cd heroku-force-ssl-sample
> heroku create
Creating frozen-fortress-6701... done, stack is cedar
https://frozen-fortress-6701.herokuapp.com/ | git@heroku.com:frozen-fortress-6701.git
Git remote heroku added

> heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
Setting config vars and restarting frozen-fortress-6701... done, v5
BUILDPACK_URL: https://github.com/ddollar/heroku-buildpack-multi.git

> git push heroku master
Fetching repository, done.
Counting objects: 1, done.
Writing objects: 100% (1/1), 197 bytes | 0 bytes/s, done.
Total 1 (delta 0), reused 0 (delta 0)

-----> Fetching custom git buildpack... done
-----> Multipack app detected
=====> Downloading Buildpack: https://github.com/ryandotsmith/nginx-buildpack.git
=====> Detected Framework: nginx-buildpack
-----> nginx-buildpack: Installed nginx/1.5.7 to app/bin
-----> nginx-buildpack: Added start-nginx to app/bin
-----> nginx-buildpack: Default mime.types copied to app/config/
-----> nginx-buildpack: Custom config found in app/config.
=====> Downloading Buildpack: https://codon-buildpacks.s3.amazonaws.com/buildpacks/heroku/ruby.tgz
=====> Detected Framework: Ruby
-----> Compiling Ruby/Rack
-----> Using Ruby version: ruby-2.0.0
-----> Installing dependencies using 1.6.3
       Running: bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin -j4 --deployment
       Using kgio 2.9.2
       Using rack 1.5.2
       Using raindrops 0.13.0
       Using bundler 1.6.3
       Using unicorn 4.8.3
       Your bundle is complete!
       Gems in the groups development and test were not installed.
       It was installed into ./vendor/bundle
       Bundle completed (0.74s)
       Cleaning up the bundler cache.
-----> Writing config/database.yml to read from DATABASE_URL

###### WARNING:
       You have not declared a Ruby version in your Gemfile.
       To set your Ruby version add this line to your Gemfile:
       ruby '2.0.0'
       # See https://devcenter.heroku.com/articles/ruby-versions for more information.

Using release configuration from last framework (Ruby).
-----> Discovering process types
       Procfile declares types     -> web
       Default types for Multipack -> console, rake

-----> Compressing... done, 13.8MB
-----> Launching... done, v6
       https://frozen-fortress-6701.herokuapp.com/ deployed to Heroku

To git@heroku.com:frozen-fortress-6701.git
 + d213969...cd72c1a master -> master (forced update)

> curl -Lv http://frozen-fortress-6701.herokuapp.com/
* Adding handle: conn: 0x7f8c38804000
* Adding handle: send: 0
* Adding handle: recv: 0
* Curl_addHandleToPipeline: length: 1
* - Conn 0 (0x7f8c38804000) send_pipe: 1, recv_pipe: 0
* About to connect() to frozen-fortress-6701.herokuapp.com port 80 (#0)
*   Trying 54.235.151.26...
* Connected to frozen-fortress-6701.herokuapp.com (54.235.151.26) port 80 (#0)
> GET / HTTP/1.1
> User-Agent: curl/7.30.0
> Host: frozen-fortress-6701.herokuapp.com
> Accept: */*
>
< HTTP/1.1 301 Moved Permanently
< Connection: keep-alive
* Server nginx is not blacklisted
< Server: nginx
< Date: Sun, 26 Oct 2014 22:13:35 GMT
< Content-Type: text/html
< Content-Length: 178
< Location: https://frozen-fortress-6701.herokuapp.com/
< Via: 1.1 vegur
<
* Ignoring the response-body
* Connection #0 to host frozen-fortress-6701.herokuapp.com left intact
* Issue another request to this URL: 'https://frozen-fortress-6701.herokuapp.com/'
* Found bundle for host frozen-fortress-6701.herokuapp.com: 0x7f8c38415200
* Adding handle: conn: 0x7f8c3a000000
* Adding handle: send: 0
* Adding handle: recv: 0
* Curl_addHandleToPipeline: length: 1
* - Conn 0 (0x7f8c38804000) send_pipe: 0, recv_pipe: 0
* - Conn 1 (0x7f8c3a000000) send_pipe: 1, recv_pipe: 0
* About to connect() to frozen-fortress-6701.herokuapp.com port 443 (#1)
*   Trying 54.235.151.26...
* Connected to frozen-fortress-6701.herokuapp.com (54.235.151.26) port 443 (#1)
* TLS 1.2 connection using TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256
* Server certificate: *.herokuapp.com
* Server certificate: DigiCert SHA2 High Assurance Server CA
* Server certificate: DigiCert High Assurance EV Root CA
> GET / HTTP/1.1
> User-Agent: curl/7.30.0
> Host: frozen-fortress-6701.herokuapp.com
> Accept: */*
>
< HTTP/1.1 200 OK
< Connection: keep-alive
* Server nginx is not blacklisted
< Server: nginx
< Date: Sun, 26 Oct 2014 22:13:35 GMT
< Content-Type: text/plain
< Transfer-Encoding: chunked
< Status: 200 OK
< Via: 1.1 vegur
<
* Connection #1 to host frozen-fortress-6701.herokuapp.com left intact
hello world%

> curl -Lv http://frozen-fortress-6701.herokuapp.com/insecure
* Adding handle: conn: 0x7f8adb004000
* Adding handle: send: 0
* Adding handle: recv: 0
* Curl_addHandleToPipeline: length: 1
* - Conn 0 (0x7f8adb004000) send_pipe: 1, recv_pipe: 0
* About to connect() to frozen-fortress-6701.herokuapp.com port 80 (#0)
*   Trying 54.235.137.114...
* Connected to frozen-fortress-6701.herokuapp.com (54.235.137.114) port 80 (#0)
> GET /insecure HTTP/1.1
> User-Agent: curl/7.30.0
> Host: frozen-fortress-6701.herokuapp.com
> Accept: */*
>
< HTTP/1.1 200 OK
< Connection: keep-alive
* Server nginx is not blacklisted
< Server: nginx
< Date: Sun, 26 Oct 2014 22:14:35 GMT
< Content-Type: text/plain
< Transfer-Encoding: chunked
< Status: 200 OK
< Via: 1.1 vegur
<
* Connection #0 to host frozen-fortress-6701.herokuapp.com left intact
hello world%
```

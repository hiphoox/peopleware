# Peopleware

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.


To depployments in production:

1) Copy and decompress tar.gz
chmod -R 777 deployments
rm -r deployments
mkdir deployments
cd deployments
tar xvf peopleware-0.0.1.tar.gz

2) Change configuration (Peopleware.Repo.url, Peopleware.Endpoint.url.host, Peopleware.Endpoint.http.port)

vim releases/0.0.1/peopleware.conf

1) Recreate database
psql -d peopleware -U peopleware -c "drop schema public cascade;"
psql -d peopleware -U peopleware -c "create schema public;"
psql -d peopleware -U peopleware -f peopleware.sql

4) Start application

bin/peopleware start/console




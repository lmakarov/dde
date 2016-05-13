# Apache Solr configuration

Add next lines in docker-compose.yml:

```yml
# Solr node
# Uncomment the service definition section below to start using Solr.
solr:
  hostname: solr
  image: blinkreaction/drupal-solr:3.x-stable
  environment:
    - DOMAIN_NAME=solr.hello-world.docker
```

Then reload your docker environment using `dsh reload` command in terminal for getting container installed and started.

## Drupal configuration

Enable all required Drupal modules for Solr search integration on your site in Drude and add your Solr server on page `admin/config/search/apachesolr/settings/add` with next settings: 

Solr server URL: `http://solr.hello-world.docker:8983/solr`

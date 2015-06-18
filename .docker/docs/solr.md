# Solr Container

[Apache Solr](http://lucene.apache.org/solr/) is a search server built atop the [Lucene](http://lucene.apache.org/core/) search engine that is commonly used to provide advanced search capbilities to websites. A Solr server can be run within a docker container.

## Configuring Solr

The default drude solr container configuration runs a Drupal-optimized Solr core based on the configuration provided by the contributed [Apache Solr Search](https://www.drupal.org/project/apachesolr) Drupal module. This includes handling of fields, terms, language, facets, and so on. Furthermore, the configuration provided in Drude also has spellcheck ("Did you mean?") enabled, as well as the Solr Cell subsystem, which uses the [Tika](https://tika.apache.org/) library to index file contents, such as PDFs and Word documents.

The Solr configuration can be found in `.docker/etc/solr`, and will be mounted into a location in the container that the Solr server will load and use. Customizations can be made to these files in a project to tailor the Solr server configuration to your needs.

## Connecting to Solr Container

The default drude configuration exposes the Solr server on the default Solr port (8983), using the hostname "solr". So to connect services to the Solr service from other containers, be sure that links are configured, and point the applications at `http://solr:8983/solr`.

You can connect to Solr from your workstation or host machine by accessing port 8983 of your host environment.
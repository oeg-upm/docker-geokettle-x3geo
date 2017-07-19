### GeoKettle Docker Image


Reason 1: this docker image was created because there was a mismatch between compatible OS versions and libraries dependencies. Also, this image has all the software necessary to run all the features of the last version of GeoKettle and it will be updated when the dependencies, libraries or OS base would be safe to be updated.

Reason 2: this docker image has been compiled with source code of GeoKettle last version and Java 8, so all the software and recent plugins are working well because there is compatibility between them. This is a critical feature, especially for Mac OS version.

--

This Docker Image includes:

 * Java OpenJDK 8 ([debian:jessie](https://github.com/docker-library/openjdk/blob/238cc35696423794b1951fc63d4cc9ffb8ca9685/8-jdk/Dockerfile))
 * [Apache Ant](https://ant.apache.org/bindownload.cgi)
 * [GeoKettle 2.5](http://www.spatialytics.org/projects/geokettle/)
 * [TripleGeoKettle](https://github.com/oeg-upm/geo.linkeddata.es-TripleGeoKettle)

--

Pull the Docker Image

```bash
docker pull oegupm/geokettle-x3geo
```

Build the Docker Image

```bash
docker build -t oegupm/geokettle-x3geo .
```

Test Docker Image with kitchen script

```bash
docker run oegupm/geokettle-x3geo kitchen.sh -version
```

Test Docker Image with sample

```bash
docker run oegupm/geokettle-x3geo pan.sh -file="/opt/samples/sample_rio.ktr" -level=Detailed -norep
```

Available commands:

* pan.sh: running transformations
* kitchen.sh: running jobs

--

Ontology Engineering Group © Copyright 2017.

Licensed under [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/).


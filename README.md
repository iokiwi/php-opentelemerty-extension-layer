# PHP Open Telemetry Extension Lambda Layer

A tiny repo to build the php opentelemetry extension as a standalone lambda layer

* https://opentelemetry.io/docs/instrumentation/php/automatic/
* https://github.com/open-telemetry/opentelemetry-php-instrumentation

The layer is based on the [bref extra php extensions] (https://github.com/brefphp/extra-php-extensions/) where I hope to eventually get this adopted thus superceding the need for this repository

## Build and Publish the Layer

```bash
# Requires `docker` and `zip`
./build.sh
```

```bash
aws lambda publish-layer-version \
    --layer-name opentelemetry-php-${PHP_VERSION} \
    --zip-file fileb://dist/layer-opentelemetry-php-${PHP_VERSION}.zip
```

## Using the Layer

```yaml
provider:
    name: aws
    region: ap-southeast-2

plugins:
  - ./vendor/bref/bref

functions:
  api:
    handler: index.php
    description: ''
    runtime: php-81-fpm
    timeout: 28 # in seconds (API Gateway has a timeout of 29 seconds)
    environment:
      OTEL_PHP_AUTOLOAD_ENABLED: true
      OTEL_TRACES_EXPORTER: console
      OTEL_METRICS_EXPORTER: none
      OTEL_LOGS_EXPORTER: none
    events:
     - httpApi: '*'
    layers:
     - arn:aws:lambda:${aws:region}:[your account id]:layer:opentelemetry-php-81:1
```

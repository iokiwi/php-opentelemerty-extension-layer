rm -rf ./tmp/ && mkdir ./tmp/
rm -rf ./dist/ && mkdir ./dist/

PHP_VERSION=81
BREF_VERSION=2

docker build \
  --build-arg PHP_VERSION="${PHP_VERSION}" \
  --build-arg BREF_VERSION="${BREF_VERSION}" \
  -t opentelemetry-php-${PHP_VERSION}:latest \
  .

# Extract extension from container
CID=$(docker create --entrypoint=scratch opentelemetry-php-${PHP_VERSION}:latest)
docker cp ${CID}:/opt ./tmp/
docker rm ${CID}

cd ./tmp/opt/
zip --quiet -X --recurse-paths ../../dist/opentelemetry-php-${PHP_VERSION}.zip .
cd ../../

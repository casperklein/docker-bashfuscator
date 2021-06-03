# docker-bashfuscator

![Version][version-shield]
![Supports amd64 architecture][amd64-shield]
![Supports aarch64 architecture][aarch64-shield]
![Supports armhf architecture][armhf-shield]
![Supports armv7 architecture][armv7-shield]
![Docker image size][image-size-shield]

Dockerized [bashfuscator](https://github.com/Bashfuscator/Bashfuscator)

## Usage

### Show help

    docker run --rm -t casperklein/bashfuscator:latest --help

### Obfuscate 'uptime'

    docker run --rm -t casperklein/bashfuscator:latest -c 'uptime'

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-blue.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-blue.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-blue.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-blue.svg
[version-shield]: https://img.shields.io/github/v/release/casperklein/docker-bashfuscator
[image-size-shield]: https://img.shields.io/docker/image-size/casperklein/bashfuscator/latest

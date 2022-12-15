# rust-docker-example

This is a minimal working example of a multi-crate docker build.
It leverages `cargo chef` for cached builds (see https://www.lpalmieri.com/posts/fast-rust-docker-builds/)


You can clone this repo and try it: 

```shell
docker build -t rust-docker .
docker run -it rust-docker:latest
```

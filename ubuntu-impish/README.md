
## Build Gimp in Container


```sh
./build-docker-images.sh
```


## Run Gimp in Container

- uses X11 forwarding,
- docker image `gimp3-gogo` with dependencies pre-installed was built along with the gimp build.


## Actually run Gimp in Container

```sh
./run-in-container.sh [args-forwarded-to-gimp]
./run-in-container.sh file.jpg
./run-in-container.sh --help
```

## Integration in GNOME Desktop

Copy file `gimp-docker.desktop` to `.local/share/applications/gimp-docker.desktop`.

Or just run `./install.sh`.

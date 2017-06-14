# Fedora Modularity documentation website

Hosted at [docs.pagure.org/modularity/](https://docs.pagure.org/modularity/)

## Contributing

If you want to change anything in the docs, please send a pull-request to this repo. Someone from the Modularity team will review and push your changes.

## Local Preview

The website is using Python Sphinx. To build it locally, install the necessary packages:

```
$ sudo dnf install python3-sphinx make
```

and build it using make:

```
$ make html
```

The result will be in `build/html/`.

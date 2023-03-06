# Create your omnibenchmark from the terminal


Here, we provide you the functionality for creating and adjusting your benchmark.

## Install omnicaster

```sh
git pull https://github.com/shdam/omnicaster.git

cd omnicaster

make install
```

## Set up a virtual environment (optional)

```sh
omnivir
```
This will create three folders in your `~/` directory called `virtenvs`, `soft`, and `omb`.
`~/virtenvs` will store the virtual environment.
`~/soft` will store `Python-3.9.2`.
`~/omb` is meant to store your benchmarks.
The `omnicaster` dependencies will be installed in the virtual environment.

## Define benchmark structure

Create a new `config` file based on `config_template`.
Specificy each parameter according to the instructions in the file.

It is recommended to create a new group or subgroup on GitLab to store your benchmark projects on. Otherwise, comment out `NAMESPACE_ID` and `GROUPNAME` to create it on your own profile.

An R function is provided that lets you create the config file from R:

```r

# Requirements: install.packages("readr")
source("create_config.R")

create_config(
	benchmark = "Your_benchmark",
	config = "config_benchmark_init",
	datanames = c("name1", "name2", "name3"),
	methodnames = c("name1", "name2"),
	metricnames = c("name1", "name2"),
	explainer = TRUE, # Adds explanation of each config parameter to the buttom of the file
	... # Add any config parameter setting (does not work with BENCHMARK, REPONAMES,
	# KEYWORDS, or TEMPLATES). Names must match the names from the template.
	)
# The config file will be called "config_<benchmark>"

```

## Creating the benchmark

Create your brand new benchmark by running

```sh

omnicaster -o -p -c CONFIGFILE

```

The `-o` and `-p` flags are used to create the `orchestrator` and `parameter` projects.


## Add new projects to your existing benchmark

Create a new config file based on the one you made previously. Edit the list parameters (REPONAMES, KEYWORDS, TEMPLATES, and PTITLES) to only contain the new project configurations, leave the rest as they were. This time exclude the `-o` and `-p` flags:

```sh

omnicaster -c CONFIGFILE

```


## Run a project in docker

This will pull and run a docker container based on an image from a specific project.

First, you need to locate the image ID found under `Packages & Registries` > `Container Registry`. Copy the latest ID. Run `omnidock -h` for extra information.

Example usage:

```sh
omnidock -r REPONAME -g GROUPNAME -i IMAGEID -gu "USER.NAME" -ge "EMAIL" -t TOKEN
```

OBS: You may use `omnidock` outside docker by using the `-p` flag:
```sh
omnidock -p -r REPONAME -g GROUPNAME -gu "USER.NAME" -ge "EMAIL" -t TOKEN
```


# Test-Driven Development TDD/ Behaviour-Driven Development  BDD Final Project

Final Project for the Coursera course **Introduction to TDD/BDD**.


## Setup

After entering the lab environment you will need to run the `setup.sh` script in the `./bin` folder to install the prerequisite software.

```bash
bash bin/setup.sh
```

Then you must exit the shell and start a new one for the Python virtual environment to be activated.

```bash
exit
```

## Tasks

Using good Test Driven Development (TDD) and Behavior Driven Development (BDD) techniques to write TDD test cases, BDD scenarios, and code, updated the following files:

```bash
tests/test_models.py
tests/test_routes.py
service/routes.py
features/products.feature
features/steps/load_steps.py
```

## License

Licensed under the Apache License. See [LICENSE](/LICENSE)

## Author

John Rofrano, Senior Technical Staff Member, DevOps Champion, @ IBM Research

## <h3 align="center"> © IBM Corporation 2023. All rights reserved. <h3/>

## Devcontainer Docker

If you need `make db` to run `docker run` from inside the devcontainer, rebuild the container image (so the Docker CLI is available) and mount the host Docker socket into the container.

- In VS Code devcontainer, add this to your `devcontainer.json` (or use the UI) and rebuild the container:

	```json
	"mounts": [
		"source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
	]
	```

- Or rebuild and run locally (example):

	```bash
	docker build -t project-dev -f Dockerfile .
	docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD":/app -p 8080:8080 project-dev
	```

After rebuilding the devcontainer with the socket mounted, `make db` should be able to use the host Docker daemon.

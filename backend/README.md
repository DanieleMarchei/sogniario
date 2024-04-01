<div id="top"></div>
<div align="center">
  
<img src="https://upload.wikimedia.org/wikipedia/it/b/bd/Logo_unicam.png" height="200">
  
# _UNICAM Sognario_

![License](https://img.shields.io/apm/l/vim-mode)
[![Made with Node](https://img.shields.io/badge/dynamic/json?label=node&query=%24.engines%5B%22node%22%5D&url=https%3A%2F%2Fraw.githubusercontent.com%2FMichaelCurrin%2Fbadge-generator%2Fmaster%2Fpackage.json)](https://nodejs.org "Go to Node.js homepage")
[![Package - Yarn](https://img.shields.io/badge/yarn->=1-blue?logo=yarn&logoColor=white)](https://classic.yarnpkg.com "Go to Yarn classic homepage")
[![Package - Typescript](https://img.shields.io/github/package-json/dependency-version/MichaelCurrin/badge-generator/dev/typescript?logo=typescript&logoColor=white)](https://www.npmjs.com/package/typescript "Go to TypeScript on NPM")

<br><br>
API services for Sogniario Unicam

</div>

# Simba

## Installation

```bash
$ yarn install
```

```bash
$ podman run --name sogniario-postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres
```

The command can only be executed via docker, but be a wise guy and use Podman, you will not regret it [link](https://developers.redhat.com/articles/2023/08/03/3-advantages-docker-podman#_2__podman_s_kubeify_feature).

### Important note!

In order to start the app you need to create a `.env` file in the root of the project.

It has to be named `.env` and be structured as follows:

```
DATABASE_HOST=host
DATABASE_USER=user
DATABASE_PASSWORD=password
DATABASE_NAME=name
DATABASE_PORT=0000
JWT_SECRET = DONOTUSETHISVALUE.INSTEAD,CREATEACOMPLEXSECRETANDKEEPITSAFEOUTSIDEOFTHESOURCECODE
```

In the DATABASE_HOST you need to insert the public ip of the AWS instance (provided in private), in DATABASE_USER and DATABASE_PASSWORD your credential (provided in private), the actual test database name in 'simba', and the port for mysql is '3306'. You DO NOT have to inset any apostrophs or quotation marks to indicate the string.

## Running the app

```bash
# development
$ yarn run start

# watch mode
$ yarn run start:dev

# production mode
$ yarn run start:prod
```

## Test

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

# Documentation

The recommended editor is Visual Studio Code, configuration files already provided by [@micrus](https://github.com/micrus), please do not change or rewrite to have the most consistent code base possible.

Allowed formatter:

- Prettier (configuration already provided)
- ESLint (configuration already provided)

Once created the .env file and runned the application, the full documentation of the API can be accessed navigating to `http://localhost:3000/api`.

# Support

Contact [@micrus](https://github.com/micrus) or [@DanieleMarchei](https://github.com/DanieleMarchei) for further information.

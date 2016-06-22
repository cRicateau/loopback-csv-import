# Loopback csv import example

This boilerplate aims to demonstrate on a simple example how to make a transactional csv import using postgreSQL.
The whole process is described in this [article](http://www.theodo.fr/blog/2016/01/how-to-make-a-user-friendly-and-transactional-csv-import-in-loopback/)


To import files directly on the database and other cool stuff on Loopback, check also [jdrouet's github](https://github.com/jdrouet).

## Requirements

Install nodejs 0.12 and postgres.

Create a database in postgres:

    createdb test


Install **libicu-dev**:

On Ubuntu:

```sh
sudo apt-get install libicu-dev
```

On MacOS with brew:

```sh
brew install icu4c
brew link icu4c --force
```

## Installation

    git clone git@github.com:cRicateau/loopback-csv-import.git

Set your datasource according to your database.

## Build

Start postresSQL then:

    npm install

You can access the example on your localhost on port 3000:  http://localhost:3000/

Try uploading the data.success.csv and the data.error.csv files.

## Run

    npm run client:watch
    npm run server:watch


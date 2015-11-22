# AP ELECTION LOADER
Relies on [the NYT/NPR AP election loader]() to get results from the AP API. Demonstrates a method putting those results into a Postgres database using the COPY method and the loader's CSV output.

## Assumptions
The following things are assumed to be true in this documentation.

* You are running OSX.
* You are using Python 2.7. (Probably the version that came OSX.)
* You have pip, [virtualenv](https://pypi.python.org/pypi/virtualenv) and [virtualenvwrapper](https://pypi.python.org/pypi/virtualenvwrapper) installed and working.

See "Chapter 2: Install Virtualenv" of NPR's [development environment blog post](http://blog.apps.npr.org/2013/06/06/how-to-setup-a-developers-environment.html) for details.

## Getting started

#### 1. Postgres
```bash
brew install postgres
createuser elex
createdb elex
psql elex
    alter user elex with superuser;
    \q
```

#### 2. Loader scripts
```bash
git clone https://github.com/nprapps/ap-election-loader && cd ap-election-loader
mkvirtualenv ap-election-loader
pip install -r requirements.txt
```

#### 3. Export environment variables
Edit `~/.virtualenvs/ap-election-loader/bin/postactivate` and add this line:

```bash
export AP_API_KEY=<MY_AP_API_KEY>
```

Then do this:

```bash
source ~/.virtualenvs/ap-election-loader/bin/postactivate
```

See more [in the loader docs]().

## Run the loader

#### 0. Configuration
* Edit [config.sh](https://github.com/newsdev/ap-election-loader/blob/master/config.sh) to set the racedate you want.

* Edit [candidate_overrides.csv](https://github.com/newsdev/ap-election-loader/blob/master/candidate_overrides.csv) if you'd like to override candidates / ballot positions with different names or descriptions.

* Bootstrap your env and database.
```
./bootstrap.sh
```

#### 1. Initial data
* Loads initial data about the race, candidates, ballot issues and reporting units.

* **Note**: Creates tables if they don't exist.
```bash
./init.sh
```

#### 2. Updates
* Loads candidate reporting unit objects into the database.

* **Note**: You might want to run this in a loop or on a cron.

* **Note**: Creates tables if they don't exist.

```bash
./update.sh
```

#### 3. Daemonized
The daemon runs `update.sh` every 30 seconds.
```
./daemon.sh
```

# Projectscope

Travis CI: [![Build Status](https://travis-ci.org/an-ju/projectscope.svg?branch=develop)](https://travis-ci.org/an-ju/projectscope)

Code Climate: [![Code Climate](https://codeclimate.com/github/an-ju/projectscope/badges/gpa.svg)](https://codeclimate.com/github/an-ju/projectscope)

Test Coverage: [![Test Coverage](https://codeclimate.com/github/an-ju/projectscope/badges/coverage.svg)](https://codeclimate.com/github/an-ju/projectscope/coverage)

A dashboard to show project metrics such as those supported by gems like
[project_metric_code_climate](https://github.com/an-ju/project_metric_code_climate),
[project_metric_github](https://github.com/an-ju/project_metric_github),
and others, using the [project_metrics](https://github.com/an-ju/project_metrics) gem to wrap
them for consumption by a Rails app

#### Instructions to run the app locally:
* bundle install --without production
* rake db:setup

We can not support github login when running locally, so please use the instructions to run without github login locally.
##### To run without github login(bypass github login)
* ADMIN_PASSWORD=some_password rails s -p $PORT -b $IP (to run app locally on cloud9 ide) 
* ADMIN_PASSWORD=some_password rails server (to run app locally in terminal)
* Then go to login/uadmin?passwd=some_password to login as admin or login/ustudent?passwd=some_password to login as student

##### To run normally (not support for github login for test/development locally)
* rails s -p $PORT -b $IP (to run app locally on cloud9 ide) 
* rails server (to run app locally in terminal


Standing up an instance
-----------------------

Environment variables required to set up the app are:
- ADMIN_PASSWORD: used to bypass the oauth system
- github_app_id: used for GitHub oauth
- github_app_token: used for GitHub oauth

Then you can use the web interface to create projects.


```rails c```


if you then run

```Project.all.each &:resample_all_metrics```

on the console it will generate a set of samples you can then see in the interface

or execute

```rake project:resample_all```

# Managing the app secret

The file `config/application.yml.asc` is a symmetric-key-encrypted YAML
file that itself contains the encryption keys for encrypting sensitive
database attributes at rest.  It is safe to version this file.  The secrets
in this file are managed [as described in this article.](http://saasbook.blogspot.com/2016/08/keeping-secrets.html)

# Creating new metric gems

Each metric gem *must* provide the following methods:

* `initialize(credentials={}, raw_data=nil)` Constructor that takes any credentials needed for the gem to contact any remote services, as a hash, and optionally takes an initial set of raw data (i.e. what would be delivered by the API of the remote service)
* `score`: computes the metric score given the current raw data
* `refresh`: refresh raw data from remote API
* `raw_data=(new_data)`: explicitly set raw data, rather than fetching from remote API
* `raw_data`: return most recent raw data
* `image`: return an image representation of the current metric state. At the moment it is a JSON string with
    * `chartType`: specifies the type of the chart, which will decide how the chart gets rendered.
    * `data`: contains data used for rendering the graph.
* `scredentials`: class method that returns a list of symbols that are the names of the configuration variables the gem expects to find in the `credentials` hash passed to it.

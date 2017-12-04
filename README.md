## Iteration 1


### TeamScope

[Overall README](./iterations/README.md)
#### Demo Video
https://youtu.be/j4X8y6C8Gw8
#### Instructions to run the app locally:
* bundle install --without production
* rake db:setup

We can not support github login when running locally, so please use the instructions to run without github login locally.
##### To run without github login(bypass github login)
* ADMIN_PASSWORD=some_password rails s -p $PORT -b $IP (to run app locally on cloud9 ide) 
* ADMIN_PASSWORD=some_password rails server (to run app locally in terminal)
Then go to login/uadmin?passwd=some_password to login as admin or login/ustudent?passwd=some_password to login as student

##### To run normally (not support for github login for test/development locally)
* rails s -p $PORT -b $IP (to run app locally on cloud9 ide) 
* rails server (to run app locally in terminal

#### CodeClimate badge showing project's current GPA
[![Maintainability](https://api.codeclimate.com/v1/badges/f110c3a7cd4b257abdd3/maintainability)](https://codeclimate.com/github/PeijieLi/cs169projectscope/maintainability)
#### Code Climate badge showing percent code coverage
 [![Test Coverage](https://api.codeclimate.com/v1/badges/f110c3a7cd4b257abdd3/test_coverage)](https://codeclimate.com/github/PeijieLi/cs169projectscope/test_coverage)
 
#### Travis CI badge showing build status for master branch (should be "passing")
[![Build Status](https://travis-ci.org/PeijieLi/cs169projectscope.svg?branch=master)](https://travis-ci.org/PeijieLi/cs169projectscope)
#### Link to deployed app on Heroku (General)
https://young-headland-90238.herokuapp.com/users/sign_in
#### Link to Pivotal Tracker project
https://www.pivotaltracker.com/n/projects/2118219
#### A brief explanation of the customer's business need that the app addresses, including a link to the customer's website
+A dashboard for teachers and students to track and visualize live metrics for progress and success in small engineering teams. TeamScope allows teachers to follow students as they work through a project, checking their adherence to protocols such as test driven development, pair programming, and point estimation for stories in real time. 
 +
 +Teachers create and manage classes of students, comparing metrics across groups in order to ensure good practices across a project’s lifecycle. Teachers can also send comments to project groups for more personalized feedback on the group’s metrics. This ensures constant feedback for students on their projects, allowing them to better measure successes, and practice software engineering techniques.
 +
 +website: http://acelab.berkeley.edu/research/teamscope/

#### Videos
[Videos](./iterations/iter0.md)


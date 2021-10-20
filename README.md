# README

To run this app you need to install PostgreSQL, Ruby 3.0.2, run bundle install and start the server with
```shell
rails s
```
You can now access the property API at localhost:3000/properties to get a list of properties for sale or for rent.
You need to add `lat`, `lng`, `property_type` and `marketing_type` as `GET` parameters to the URL.

To efficiently load the properties also for big amounts of data there are 3 indexes for
* `property_type`
* `marketing_type`
* `ll_to_earth(lat, lng)`

The last index is used to efficiently filter by location via the postgres `earth_box` function together with the 
cube operator `@>` as [described here](https://www.postgresql.org/docs/9.6/earthdistance.html).


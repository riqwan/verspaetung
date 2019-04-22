# Verspaetung Challenge

Problem
In the fictional city of Verspaetung, public transport is notoriously unreliable. To tackle the problem, the city council has decided to make the public transport timetable and delay information public, opening up opportunities for innovative use cases.

You are given the task of writing a web API to expose the Verspaetung public transport information.

As a side note, the city of Verspaetung has been built on a strict grid - all location information can be assumed to be from a cartesian coordinate system.

Data
The Verspaetung public transport information is comprised of 4 CSV files:
lines.csv - the public transport lines.
stops.csv - the stops along each line.
times.csv - the time vehicles arrive & depart at each stop. The timetimestamp is in the format of HH:MM:SS.
delays.csv - the delays for each line. This data is static and assumed to be valid for any time of day.

Challenge

Build a web API which provides the following features:

Find a vehicle for a given time and X & Y coordinates Return the vehicle arriving next at a given stop Indicate if a given line is currently delayed
Endpoints should be available via port 8081

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

* Rails 5.2.3
* Ruby 2.5.0
* SQLite 3

### Installing

Steps to get a development version running:

```shell
  Git clone the repository
```
```shell
  cd verspaetung
```
```shell
  bundle install
```
```shell
  rake db:setup
```

## Running the tests
```shell
rspec
```

### Simple (barebones) Documentation

**Find a vehicle for a given time and X & Y coordinates**
----
  Returns json data about a single transport time that includes the details of the vehicle.

* **URL**

  `/api/v1/transport_time`

* **Method:**

  `GET`

*  **URL Params**

   **Required:**

   `x=[integer]`
   `y=[integer]`
   `time=[string(datetime)]`

* **Data Params**

  `None`

* **Success Response:**

  * **Code:** `200` <br />
    **Content:** `{'id'=>466, 'time'=>'2018-10-11T08:00:00.000Z', 'transport_stop'=>{'id'=>13, 'x'=>4, 'y'=>4}, 'transport_line'=>{'id'=>4, 'name'=>'M4', 'is_delayed'=>false}}`

* **Error Response:**

  * **Code:** `400 Bad Request` <br />
    **Content:** `"error"=>{"x"=>["can't be blank", "is not a number"], "y"=>["can't be blank", "is not a number"], "time"=>["can't be blank"]}}`


**Return the vehicle arriving next at a given stop**
----
  Returns json data about a single transport stop that includes the details of the next vehicle arriving.

* **URL**

  `/api/v1/transport_stops/:id`

* **Method:**

  `GET`

*  **URL Params**

   **Required:**

   `id=[integer]`

* **Data Params**

  `None`

* **Success Response:**

  * **Code:** `200` <br />
    **Content:** `{"id"=>13, "x"=>4, "y"=>4, "next_transport_time"=>{"id"=>466, "time"=>"2018-10-11T08:00:00.000Z"}}`

* **Error Response:**

  * **Code:** `404 Not Found` <br />
    **Content:** `{"error"=>"Couldn't find TransportStop with 'id'=99999"}`


**Indicate if a given line is currently delayed**
----
  Returns json data about a single transport line that includes the details of whether it is delayed or not

* **URL**

  `/api/v1/transport_lines/:id`

* **Method:**

  `GET`

*  **URL Params**

   **Required:**

   `id=[integer]`

* **Data Params**

  `None`

* **Success Response:**

  * **Code:** `200` <br />
    **Content:** `{"id"=>4, "name"=>"M4", "is_delayed"=>true}`

* **Error Response:**

  * **Code:** `404 Not Found` <br />
    **Content:** `{"error"=>"Couldn't find TransportLine with 'id'=99999"}`
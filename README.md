# Terminal POC

## Getting Started

### Requirements

- Ruby 2.7.5
- Rails 6.1.5
- Postgres 11

### Project setup

Terminal POC project is a pretty straightforward Rails app.  It requires Ruby and Postgres.

After checking out the code, just do:

```bash
cp .env.sample .env
bundle
rails db:setup
rails server
```

>make sure to set all the environment variables in .env


#### About ngrok

[ngrok](https://ngrok.com/) is used to expose a URL to receive the webhook events

use it like: `ngrok http 3000`

>make sure to set `NGROK_HOST` as the HTTPS address that ngrok will provide

## Sample API Usage

In order to create a request and start getting updates, just hit the following endpoint with your `bill_of_lading` and `scac`, and look `public/results.csv` for changes.

```
HTTP Verb: POST
URL: http://localhost:3000/v1/requests
Headers: { "Content-Type"  => "application/vnd.api+json" }
body:
{
  "data": {
    "type": "requests",
    "attributes": {
      "bill_of_lading": "W226267303",
      "scac": "YMLU"
    }
  }
}
```


## Testing

* Test are written using [rspec-rails](https://github.com/rspec/rspec-rails) and you can run the suite using:

```
bundle exec rspec
```

## Author
This was written by [edymerchk](https://github.com/edymerchk).

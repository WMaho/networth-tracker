# Networth Tracker
Simple networth charting app

## Setup

Generate API Key from then place within config/application.yml
```
https://www.alphavantage.co/support/#api-key
```

Launch Rails server


Launch Jobs servers/workers
```
redis-server
QUEUE=create rake resque:work
QUEUE=update rake resque:work
```
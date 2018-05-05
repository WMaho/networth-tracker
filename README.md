Generate API Key from then place within config/application.yml
https://www.alphavantage.co/support/#api-key

Launch Server

Launch Jobs servers/workers
redis-server
QUEUE=create rake resque:work
QUEUE=update rake resque:work
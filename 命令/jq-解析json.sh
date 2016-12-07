

[yjj@centos ~]$ cat 1
{"@timestamp":"2016-07-24T23:23:22.000Z","http_host":"www.open01.com","status":302,"scheme":"http","request":"/Status/Version","method":"GET","remote_addr":"101.251.193.34","request_time":0,"response_time":0,"body_bytes_sent":154,"http_referrer":"-","http_user_agent":"-","http_x_forwarded_for":"-","http_upstream":"-","cookie_id":"-","user_id":0,"session_id":"-","cookie_stock_flight":"-","@version":"1","form":"nginx_access_json","host":"lb-02.lan.zhaowei.open01.com","path":"/var/log/nginx/access.json","client_addr":"101.251.193.34"}
[yjj@centos ~]$ cat 1|jq '.status=404'
{
  "client_addr": "101.251.193.34",
  "path": "/var/log/nginx/access.json",
  "host": "lb-02.lan.zhaowei.open01.com",
  "form": "nginx_access_json",
  "@version": "1",
  "cookie_stock_flight": "-",
  "session_id": "-",
  "request_time": 0,
  "remote_addr": "101.251.193.34",
  "method": "GET",
  "request": "/Status/Version",
  "scheme": "http",
  "status": 404,
  "http_host": "www.open01.com",
  "@timestamp": "2016-07-24T23:23:22.000Z",
  "response_time": 0,
  "body_bytes_sent": 154,
  "http_referrer": "-",
  "http_user_agent": "-",
  "http_x_forwarded_for": "-",
  "http_upstream": "-",
  "cookie_id": "-",
  "user_id": 0
}

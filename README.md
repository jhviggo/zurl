# Zurl HTTP CLI

Curl but in Zig.
Supports only HTTP/HTTPS and POST, GET, PUT.
Supports only JSON for POST and PUT.

CLI format `zurl ${url} ${...options}`

## examples
```
zurl https://www.api.com/test
zurl https://www.api.com/test --request POST --data '{"data":"test123"}' --header "Content-Type: application/json"
```


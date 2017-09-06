# Load Balancer Real Server IP Toggle

This VSTS extension can be used to toggle Real Server IPs in a Kemp Load Balancer.

You can provide a username, password, and URL of your Kemp Load Balancer and then select whether to `Enable` or `Disable` your Real Server. As part of your build artifacts, include a JSON file that includes an array of objects like the following:

```
[
  {
    "Label": "prod_website_web01",
    "RealServerIP": "10.9.15.207"
  }
]
```

*Legal disclaimer:*

>Seven Corners, Inc. is in no way affiliated with KEMP Technologies. To find out more information about KEMP and their products, please visit their website [here](https://kemptechnologies.com). KEMP® and KEMP Technologies® are trademarks of KEMP Technologies, Inc.

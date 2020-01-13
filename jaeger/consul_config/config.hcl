data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "dc1"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  grpc = 8502
}

connect {
  enabled = true
}

advertise_addr = "10.7.0.2"
enable_central_service_config = true

config_entries {
  bootstrap = [
    {
      kind = "proxy-defaults"
      name = "global"

      config {
        envoy_extra_static_clusters_json = <<EOL
          {
            "connect_timeout": "3.000s",
            "dns_lookup_family": "V4_ONLY",
            "lb_policy": "ROUND_ROBIN",
            "load_assignment": {
                "cluster_name": "zipkin",
                "endpoints": [
                    {
                        "lb_endpoints": [
                            {
                                "endpoint": {
                                    "address": {
                                        "socket_address": {
                                            "address": "aac8b0ad5363b11ea8a5402a4e25409d-1210352576.us-west-2.elb.amazonaws.com",
                                            "port_value": 9411,
                                            "protocol": "TCP"
                                        }
                                    }
                                }
                            }
                        ]
                    }
                ]
            },
            "name": "zipkin",
            "type": "STRICT_DNS"
          }
        EOL

        envoy_tracing_json = <<EOL
          {
              "http": {
                  "name": "envoy.zipkin",
                  "config": {
                      "collector_cluster": "zipkin",
                      "collector_endpoint": "/api/v1/spans"
                  }
              }
          }
        EOL
      }
    }
  ]
}

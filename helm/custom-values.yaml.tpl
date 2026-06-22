global:
  # Increase memory so Java apps don't OOMKill on startup
  resources:
    requests:
      memory: 64Mi
      cpu: 50m
    limits:
      memory: 384Mi
      cpu: 200m

# Disable in-cluster databases — use managed AWS RDS instead
catalog:
  mysql:
    enabled: false
  db:
    endpoint: "${CATALOG_DB_ENDPOINT}"
    user: "dbadmin"
    password: "${CATALOG_DB_PASSWORD}"

orders:
  postgresql:
    enabled: false
  db:
    endpoint: "${ORDERS_DB_ENDPOINT}"
    user: "dbadmin"
    password: "${ORDERS_DB_PASSWORD}"

# Use managed AWS DynamoDB (not in-cluster DynamoDB Local)
carts:
  dynamodb:
    tableName: "bedrock-carts"
  dynamodb-local:
    enabled: false
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: "${CARTS_IRSA_ROLE_ARN}"

# Message brokers can remain in-cluster as per requirements
rabbitmq:
  enabled: true
redis:
  enabled: true

# UI exposed via ALB Ingress — no longer needs LoadBalancer service type
ui:
  service:
    type: ClusterIP
  endpoints:
    catalog: http://retail-store-catalog:80
    carts: http://retail-store-carts:80
    checkout: http://retail-store-checkout:80
    orders: http://retail-store-orders:80
    assets: http://retail-store-assets:80

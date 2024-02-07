# web-analytics
Our web analytics stack.

The underlying tool is [Plausible](https://plausible.io/).

## Deployment

The service is continuously deployed by GitHub Actions.

## Testing

This can be deployed to a local Docker Kubernetes cluster.

### Prerequisites

- Make sure Docker Desktop is running with Kubernetes enabled and the Kubernetes Context is `docker-desktop`.
- [kubectl](https://developer.hashicorp.com/terraform/cli) is installed

### Steps

1. Set environment variables:
   ```sh
   export RUNTIME_DOMAIN=local
   export BASE_URL=http://localhost:8000
   export MAILER_EMAIL=web-analytics-local@digitalsociety.coop
   export SMTP_HOST_ADDR=smtp.mailersend.net
   export SMTP_HOST_PORT=587
   export SMTP_EMAIL=MS_SXORAI@digitalsociety.coop
   export SMTP_PASSWORD=password # note this needs changing
   export SECRET_KEY_BASE=$(openssl rand -base64 64 | tr -d '\n' ; echo)
   export POSTGRES_PASSWORD=password
   export CLICKHOUSE_PASSWORD=password
   ```
1. Run the deployment script:
   ```sh
   ./deploy.sh local
   ```

Plausible will be available on `http://localhost:8000`

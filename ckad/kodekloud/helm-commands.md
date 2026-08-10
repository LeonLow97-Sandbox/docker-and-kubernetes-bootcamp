# Helm

```sh
# -----------------------------------------------------------------------------
# Repository Management
# -----------------------------------------------------------------------------

# Add a chart repository, it tells your local Helm client about a chart repository.
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update local repository indexes
helm repo update

# List configured repositories
helm repo list

# Search for charts
helm search repo wordpress


# -----------------------------------------------------------------------------
# Chart Inspection
# -----------------------------------------------------------------------------

# Show default values
helm show values bitnami/wordpress

# Download chart without installing
helm pull bitnami/wordpress --untar
helm pull bitnami/apache --untar --version=10.1.1 # with version number
helm pull bitnami/apache --untar --version=10.1.1 --destination=/root


# -----------------------------------------------------------------------------
# Install <repo_name>/<chart_name>
# -----------------------------------------------------------------------------

# Install a chart
helm install wordpress bitnami/wordpress

# Install into a namespace
helm install wordpress bitnami/wordpress \
  -n web \
  --create-namespace

# Install with a values file
helm install wordpress bitnami/wordpress \
  -f values.yaml

# Install with command-line overrides
helm install wordpress bitnami/wordpress \
  --set service.type=ClusterIP

# Preview rendered manifests (no install)
helm template wordpress bitnami/wordpress

# Simulate an installation
helm install wordpress bitnami/wordpress \
  --dry-run --debug

# Install helm chart locally.
helm install mywebapp ./apache


# -----------------------------------------------------------------------------
# Release Management
# -----------------------------------------------------------------------------

# List releases in k8s cluster
helm list

# Show release status
helm status wordpress

# Show release history
helm history wordpress

# Show values used by a release
helm get values wordpress


# -----------------------------------------------------------------------------
# Upgrade / Rollback
# -----------------------------------------------------------------------------

# Upgrade a release
helm upgrade wordpress bitnami/wordpress

# Upgrade or install if it doesn't exist
helm upgrade --install wordpress bitnami/wordpress

# Roll back to revision 1
helm rollback wordpress 1


# -----------------------------------------------------------------------------
# Uninstall
# -----------------------------------------------------------------------------

# Remove a release
helm uninstall wordpress
```

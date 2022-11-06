# Testing Helmfile

## Prerequisites

1. CentOS 7
1. Docker

## Install OKD 3.11 Client Tools

```bash
openshift_version='3.11.0' && openshift_build='0cbc58b' && \
curl -Ls "https://github.com/openshift/origin/releases/download/v${openshift_version}/openshift-origin-client-tools-v${openshift_version}-${openshift_build}-linux-64bit.tar.gz" \
  | sudo tar -xz --strip-components=1 -C /usr/bin "openshift-origin-client-tools-v${openshift_version}-${openshift_build}-linux-64bit/oc"
```

## Install Helm

```bash
helm_version='3.10.0' && \
curl -Ls "https://get.helm.sh/helm-v${helm_version}-linux-amd64.tar.gz" \
  | sudo tar -xz --strip-components=1 -C /usr/local/bin "linux-amd64/helm"
```

## Install Helmfile

```bash
helmfile_version='0.147.0' && \
curl -Ls "https://github.com/helmfile/helmfile/releases/download/v${helmfile_version}/helmfile_${helmfile_version}_linux_amd64.tar.gz" \
  | sudo tar -xz -C /usr/local/bin helmfile && \
sudo chown root:root /usr/local/bin/helmfile
```

## Create OpenShift cluster

```bash
oc cluster up \
  --base-dir="${HOME}/openshift.local.clusterup" \
  --enable="router"
```

## Install Helm release with Helm

```bash
openshift_user='developer' && \
openshift_password='developer' && \
openshift_api_server='https://127.0.0.1:8443' && \
oc login -u "${openshift_user}" -p "${openshift_password}" --insecure-skip-tls-verify "${openshift_api_server}" && \
openshift_token="$(oc whoami -t)" && \
rm -f ~/.kube/config && \
openshift_namespace='myproject' && \
helm upgrade my-release charts/my-chart \
  --kube-apiserver "${openshift_api_server}" \
  --kube-token "${openshift_token}" \
  --kube-insecure-skip-tls-verify \
  -n "${openshift_namespace}" \
  --install --wait
```

## Access installed release

```bash
curl -s --resolve chart-example.local:80:127.0.0.1 http://chart-example.local/
```

## Uninstall Helm release with Helm

```bash
openshift_user='developer' && \
openshift_password='developer' && \
openshift_api_server='https://127.0.0.1:8443' && \
oc login -u "${openshift_user}" -p "${openshift_password}" --insecure-skip-tls-verify "${openshift_api_server}" && \
openshift_token="$(oc whoami -t)" && \
rm -f ~/.kube/config && \
openshift_namespace='myproject' && \
helm uninstall my-release \
  --kube-apiserver "${openshift_api_server}" \
  --kube-token "${openshift_token}" \
  --kube-insecure-skip-tls-verify \
  -n "${openshift_namespace}" \
  --wait
```

## Install Helm release with Helmfile

```bash
openshift_user='developer' && \
openshift_password='developer' && \
openshift_api_server='https://127.0.0.1:8443' && \
oc login -u "${openshift_user}" -p "${openshift_password}" --insecure-skip-tls-verify "${openshift_api_server}" && \
openshift_token="$(oc whoami -t)" && \
rm -f ~/.kube/config && \
helm_args="--kube-apiserver $(printf '%q' "${openshift_api_server}")" && \
helm_args="${helm_args} --kube-token $(printf '%q' "${openshift_token}")" && \
helm_args="${helm_args} --kube-insecure-skip-tls-verify" && \
helmfile sync -e local --args "${helm_args}" --wait
```

## Uninstall Helm release with Helmfile

```bash
openshift_user='developer' && \
openshift_password='developer' && \
openshift_api_server='https://127.0.0.1:8443' && \
oc login -u "${openshift_user}" -p "${openshift_password}" --insecure-skip-tls-verify "${openshift_api_server}" && \
openshift_token="$(oc whoami -t)" && \
rm -f ~/.kube/config && \
helm_args="--kube-apiserver $(printf '%q' "${openshift_api_server}")" && \
helm_args="${helm_args} --kube-token $(printf '%q' "${openshift_token}")" && \
helm_args="${helm_args} --kube-insecure-skip-tls-verify" && \
helmfile destroy -e local --args "${helm_args}"
```

## Remove OpenShift cluster

```bash
oc cluster down && \
for openshift_mount in $(mount | grep openshift | awk '{ print $3 }'); do \
  echo "Unmounting ${openshift_mount}" && sudo umount "${openshift_mount}"; \
done && \
sudo rm -rf "${HOME}/openshift.local.clusterup"
```

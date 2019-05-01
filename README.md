# example-pipelines
Example pipelines to be used with Tekton.

Covers the use case of cloning code from a GitHub repository, building and pushing it to a Docker registry, then deploying the application using either kubectl or Helm.

# Helm pipeline example
The Helm pipelines have been tested with the experimental webhook-extension [webhooks-extension](https://github.com/tektoncd/experimental/tree/master/webhooks-extension).

To get started...

- Have the Helm client installed and a Tiller somewhere (e.g. Docker for Desktop)
- Determine whether you're using a secure Tiller or not (hint, do: `helm version` - can you contact the server after you've done a `helm init`?)
- If it's a secure tiller you will be using `helm-deploy-task.yaml` and `helm-pipeline.yaml`
- Otherwise you will be using `helm-insecure-deploy-task.yaml` and `helm-insecure-pipeline.yaml`

- Run:

```bash
kubectl apply -f config
```

This gives you all of the pipeline and task definitions.

If you're not using the webhook-extension, you will need to create a PipelineRun manually. An example is provided below.

If you are using the webhook-extension, follow the instructions at the webhook-extension folder above: this will involve creating a webhook that, when triggered (e.g on a Git push), a 
pipeline will be run for you (e.g. `simple-helm-pipeline-insecure` if you wish to deploy to an insecure Tiller, such as one you've set up on Docker for Desktop).

# Example PipelineRun

```yaml
apiVersion: tekton.dev/v1alpha1
kind: PipelineResource
metadata:
  name: git-source
spec:
  type: git
  params:
  - name: revision
    value: master
  - name: url
    value: https://github.com/a-roberts/simple-node.git
---

apiVersion: tekton.dev/v1alpha1
kind: PipelineResource
metadata:
  name: docker-image
spec:
  type: image
  params:
  - name: url
    value: docker.io/<myusername>/<myappname>
---

apiVersion: tekton.dev/v1alpha1
kind: PipelineRun
metadata:
  name: simple-pipeline-run
spec:
  pipelineRef:
    name: simple-helm-pipeline-insecure # Change if you want to use another
  trigger:
    type: manual
  serviceAccount: 'default'
  resources:
  - name: git-source
    resourceRef:
      name: git-source
  - name: docker-image
    resourceRef:
      name: docker-image
```

Apply the above after making any modifications to point to your own Docker registry and GitHub repository.






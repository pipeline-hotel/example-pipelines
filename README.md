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

# Do this if you want to push to Dockerhub

You will need a Docker secret and patched sevice account in order to push to your own registry, for example on Dockerhub (tested with tektoncd/pipeline version 0.2) you can use the provided `secret-me-up.sh` script.

# Example PipelineRun and PipelineResources

Remember, you only need to do this if you want to kick off a PipelineRun manually.

Look in and modify `ManualPipelineRunAndResources.yaml` to point to your own locations, then `kubectl apply -f ManualPipelineRunAndResources.yaml`.
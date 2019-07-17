# example-pipelines

Example pipelines to be used with Tekton.

Covers the use case of cloning code from a GitHub repository, building and pushing it to a Docker registry, then deploying the application using either kubectl or Helm.

# Helm pipeline example

The Helm pipelines have been tested with the experimental webhook-extension [webhooks-extension](https://github.com/tektoncd/experimental/tree/master/webhooks-extension).

If you are using the webhook-extension, follow the instructions at the webhook-extension folder above: this will involve creating a webhook that, when triggered (e.g on a Git push), a 
pipeline will be run for you (e.g. `simple-helm-pipeline-insecure` if you wish to deploy to an insecure Tiller, such as one you've set up on Docker for Desktop).

## Pushing to a Docker registry

You will need a Docker secret and patched sevice account in order to push to your own registry, for example on Dockerhub (tested with tektoncd/pipeline version 0.2) you can use the provided `create-tekton-docker-secret.sh` script.

__Assumptions:__

- You have a Tiller somewhere and can talk to it (e.g. with `helm list`).
- If it's a secure tiller you will be using `helm-deploy-task.yaml` and `helm-pipeline.yaml`, otherwise you will be using `helm-insecure-deploy-task.yaml` and `helm-insecure-pipeline.yaml`

__What do I do?__

```bash
kubectl apply -f config
```

This gives you all of the pipeline and task definitions.

If you are **not** using the webhook extension, you will need to create a PipelineRun and its resources manually. An example is detailed provided below.

## Example PipelineRun and PipelineResources

__Remember, you only need to do this if you want to kick off a PipelineRun manually.__

- Modify `runner.yaml` to point to your own locations for GitHub and Dockerhub in the PipelineResources
- Modify the PipelineRun parameters to point to your own repository name, Helm chart folder name, and push location
- Run `kubectl apply -f runner.yaml`
- Watch as the build-simple and deploy-simple pods run and complete. If they didn't, make sure you view the pod logs (optionally using the `--all-containers` flag)
- If no pods appear, it helps to `get` your created PipelineRun (for example as `json`) to be able to debug the problem

## Buildah

The `buildah` pipeline in `config/catalog-buildah-pipeline.yaml` uses the `buildah` task from https://github.com/tektoncd/catalog/blob/master/buildah/buildah.yaml. 
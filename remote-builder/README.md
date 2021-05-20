# Remote builder pattern

This is an example of how a parent build can kick off a child build, in this case to run a potentially more expensive build step for a shorter amount of time. 

## Kicking off the parent build

This will kick off the build defined in `parent-build.yaml`. 

```
gcloud builds submit --config=parent-build.yaml
```

## Running the child build as a step in the parent build

The `parent-build.yaml` utilizes the gcloud container image to kick off the build defined in `child-build.yaml`. 

It will then complete the remainder of the build upon successful completion of `child-build.yaml`. 

```
# parent-build.yaml

steps:
- name: 'bash'
  id: bash-1
  args:
   - 'sleep'
   - '30'

- name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  id: child-build
  entrypoint: 'gcloud'
  args:
  - 'builds'
  - 'submit'
  - '--config'
  - './child-build.yaml'
  waitFor: ['bash-1']

- name: 'bash'
  id: bash-2
  args:
   - 'sleep'
   - '30'
  waitFor: ['child-build']
  ```
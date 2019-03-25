# rancher cli docker integration

## about

This is a small helper image to run rancher 2.0 cli command from gitlab.

## env vars

| var        | description                                                         |
|------------|---------------------------------------------------------------------|
| URL        | URL of rancher server                                               |
| TOKEN      | API token                                                           |
| CONTEXT    | Rancher context key                                                 |
| DEPLOYMENT | name of the deployment                                              |
| NAMESPACE  | define the namespace which should be used                           |
| CONTAINER  | name of the container which should be updated                       |
| IMAGE      | the image name and version                                          |


## gitlab-ci integration

Step 1: Add all ENV as CI vars to your project

Step 2: add the following step to your `.gitlab-ci.yml`

```
deploy:
  stage: deploy
  tags:
    - docker
  script:
    - docker run -e "URL=$URL" -e "TOKEN=$TOKEN" -e "CONTEXT=$CONTEXT" -e "DEPLOYMENT=$DEPLOYMENT" -e "NAMESPACE=$NAMESPACE" -e "CONTAINER=$CONTAINER" -e "IMAGE=$CONTAINER_RELEASE_IMAGE" loumaris/rancher
  only:
    - master
```
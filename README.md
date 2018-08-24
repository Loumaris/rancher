# rancher cli docker integration

## about

This is a small helper image to run rancher 2.0 cli command from gitlab.

## env vars

| var        | description                                                         |
|------------|---------------------------------------------------------------------|
| URL        | URL of rancher server                                               |
| TOKEN      | API token                                                           |
| CONTEXT    | Rancher context key                                                 |
| CA         | base64 encoded string of ca certificate (can be find in rancher ui) |
| DEPLOYMENT | name of the deployment                                              |
| NAMESPACE  | define the namespace which should be used                           |
| CONTAINER  | name of the container which should be updated                       |
| IMAGE      | the image name and version                                          |

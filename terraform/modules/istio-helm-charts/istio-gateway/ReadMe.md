# ArgoCD

### Sources

ArgoCD Helm Repository: https://argoproj.github.io/argo-helm

ArgoCD GitHub Repository: https://github.com/argoproj/argo-cd

ArgoCD webpage: https://argoproj.github.io/argo-cd/getting_started/

- - - - - 

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. Controlling ArgoCD can be done via Web Portal
or via ArgoCD CLI. The communication via CLI is using gRPC protocol. 

## Installation information

* This Helm Chart is prepared to create namespace with name 'argocd' for you. 
  You need to make sure that you create all ArgoCD resources in "argocd" namespace by running command:

` helm install argocd ./common/argocd -n argocd --dry-run`

* First login to UI portal:

    When first install ArgoCD, ArgoCD is auto-generating the default login and password for admin account. The password is then store 
  in K8S secrets encoded as base64 string. Reaching the password required running the command:
  
`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

Then sign in to argocd api server by:

username: admin <br>
password: < secret get from k8s secret store >

* Changing password:

Run this command: 

`argocd account update-password`

You should delete the argocd-initial-admin-secret from the Argo CD namespace once you changed the password. The secret serves no other purpose than to store the initially generated password in clear and can safely be deleted at any time. It will be re-created on demand by Argo CD if a new admin password must be re-generated.
    


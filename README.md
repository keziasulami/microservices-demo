<p align="center">
<img src="src/frontend/static/icons/Hipster_HeroLogoCyan.svg" width="300"/>
</p>



**Online Boutique** is a cloud-native microservices demo application.
Online Boutique consists of a 10-tier microservices application. The application is a
web-based e-commerce app where users can browse items,
add them to the cart, and purchase them.

**Google uses this application to demonstrate use of technologies like
Kubernetes/GKE, Istio, Stackdriver, gRPC and OpenCensus**. This application
works on any Kubernetes cluster (such as a local one), as well as Google
Kubernetes Engine. It’s **easy to deploy with little to no configuration**.

If you’re using this demo, please **★Star** this repository to show your interest!

> 👓**Note to Googlers:** Please fill out the form at
> [go/microservices-demo](http://go/microservices-demo) if you are using this
> application.

Looking for the old Hipster Shop frontend interface? Use the [manifests](https://github.com/GoogleCloudPlatform/microservices-demo/tree/v0.1.5/kubernetes-manifests) in release [v0.1.5](https://github.com/GoogleCloudPlatform/microservices-demo/releases/v0.1.5).

## Screenshots

| Home Page                                                                                                         | Checkout Screen                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| [![Screenshot of store homepage](./docs/img/online-boutique-frontend-1.png)](./docs/img/online-boutique-frontend-1.png) | [![Screenshot of checkout screen](./docs/img/online-boutique-frontend-2.png)](./docs/img/online-boutique-frontend-2.png) |

## Service Architecture

**Online Boutique** is composed of many microservices written in different
languages that talk to each other over gRPC.

[![Architecture of
microservices](./docs/img/architecture-diagram.png)](./docs/img/architecture-diagram.png)

Find **Protocol Buffers Descriptions** at the [`./pb` directory](./pb).

| Service                                              | Language      | Description                                                                                                                       |
| ---------------------------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| [frontend](./src/frontend)                           | Go            | Exposes an HTTP server to serve the website. Does not require signup/login and generates session IDs for all users automatically. |
| [cartservice](./src/cartservice)                     | C#            | Stores the items in the user's shopping cart in Redis and retrieves it.                                                           |
| [productcatalogservice](./src/productcatalogservice) | Go            | Provides the list of products from a JSON file and ability to search products and get individual products.                        |
| [currencyservice](./src/currencyservice)             | Node.js       | Converts one money amount to another currency. Uses real values fetched from European Central Bank. It's the highest QPS service. |
| [paymentservice](./src/paymentservice)               | Node.js       | Charges the given credit card info (mock) with the given amount and returns a transaction ID.                                     |
| [shippingservice](./src/shippingservice)             | Go            | Gives shipping cost estimates based on the shopping cart. Ships items to the given address (mock)                                 |
| [emailservice](./src/emailservice)                   | Python        | Sends users an order confirmation email (mock).                                                                                   |
| [checkoutservice](./src/checkoutservice)             | Go            | Retrieves user cart, prepares order and orchestrates the payment, shipping and the email notification.                            |
| [recommendationservice](./src/recommendationservice) | Python        | Recommends other products based on what's given in the cart.                                                                      |
| [adservice](./src/adservice)                         | Java          | Provides text ads based on given context words.                                                                                   |
| [loadgenerator](./src/loadgenerator)                 | Python/Locust | Continuously sends requests imitating realistic user shopping flows to the frontend.                                              |

## Features

- **[Kubernetes](https://kubernetes.io)/[GKE](https://cloud.google.com/kubernetes-engine/):**
  The app is designed to run on Kubernetes (both locally on "Docker for
  Desktop", as well as on the cloud with GKE).
- **[gRPC](https://grpc.io):** Microservices use a high volume of gRPC calls to
  communicate to each other.
- **[Istio](https://istio.io):** Application works on Istio service mesh.
- **[OpenCensus](https://opencensus.io/) Tracing:** Most services are
  instrumented using OpenCensus trace interceptors for gRPC/HTTP.
- **[Stackdriver APM](https://cloud.google.com/stackdriver/):** Many services
  are instrumented with **Profiling**, **Tracing** and **Debugging**. In
  addition to these, using Istio enables features like Request/Response
  **Metrics** and **Context Graph** out of the box. When it is running out of
  Google Cloud, this code path remains inactive.
- **[Skaffold](https://skaffold.dev):** Application
  is deployed to Kubernetes with a single command using Skaffold.
- **Synthetic Load Generation:** The application demo comes with a background
  job that creates realistic usage patterns on the website using
  [Locust](https://locust.io/) load generator.

### Additional Features

1. **[Firebase Authentication](https://firebase.google.com/products/auth):** The application provides user authentication by Sign in with Google Account and autofill the user's email when checkout.
2. **[Firestore](https://cloud.google.com/firestore) & [Cloud Storage](https://cloud.google.com/storage):** The application fetches its products from Firestore, and the product images can be stored on Cloud Storage.
3. **[Cloud SQL](https://cloud.google.com/sql):** The application uses Cloud SQL to store Order information.
4. **[Terraform](https://www.terraform.io/):** The application use Terraform to automate creation and teardown of various GCP resources such as GKE cluster, Cloud Storage, and Cloud SQL instance.

## Installation

We offer the following installation method:

**Running on Google Kubernetes Engine (GKE)”** (~30 minutes)

- You will build,
upload and deploy the container images to a Kubernetes cluster on Google
Cloud.

### Prerequisites

   - kubectl (can be installed via `gcloud components install kubectl`)
   - [skaffold]( https://skaffold.dev/docs/install/) ([ensure version ≥v1.10](https://github.com/GoogleContainerTools/skaffold/releases))
   - Enable GCP APIs for Cloud Monitoring, Tracing, Debugger:
       ```shell
       gcloud services enable monitoring.googleapis.com \
           cloudtrace.googleapis.com \
           clouddebugger.googleapis.com
       ```

### Running on Google Kubernetes Engine (GKE)

> 💡 You can try it on a realistic cluster using Google Cloud Platform.

1. Enable Google Kubernetes Engine API

        gcloud services enable container.googleapis.com

2. Run `terraform apply` in the directory `/terraform`. Enter your GCP Project ID and then `yes`.

    It will create GCP resources used in the application:

    |Resources            |Explanation|
    |---------------------|-----------|
    |GKE cluster          |For deployment|
    |Cloud Storage Buckets|Product images, Firestore backup|
    |Cloud Storage Objects|Product images|
    |Cloud SQL Instance   |Store Order information|
    |Service Accounts     |For Firestore, Cloud SQL|

3. Connect `kubectl` with cluster `demo`

        gcloud container clusters get-credentials demo --zone asia-east1-a --project <GCP_project_ID>

4. Configuring Firebase Authentication

    - Create a new Firebase Project on [Firebase Console](http://console.firebase.google.com/) and connect it with your GCP Project.
    - Go to Project Settings on the Firebase Console to get your `firebaseConfig`.
    - Update `firebaseConfig` [here](/src/frontend/templates/footer.html) accordingly (necessary fields only).

5. Configuring Cloud Firestore

    - On the GCP Console, go to Firestore and select **Native Mode.**
    - Copy [firestore-backup](/firestore-backup) to the  Cloud Storage Bucket created by Terraform
        ```shell
        gsutil cp -r firestore-backup/content gs://<Project ID>-firestore-backup
        ```
    - Import Firestore backup from the Cloud Storage Bucket
        ```shell
        gcloud firestore import gs://<Project ID>-firestore-backup/content/
        ```
    - On the Firestore interface, update the value of `picture` field on each products because your product image links are different. Change them to `https://storage.googleapis.com/<Project ID>-product-image/xxx.jpg`.
    - Update `projectID` for the Firestore client [here](/src/productcatalogservice/server.go).
    - Create a new  JSON key of the service account `firestore-sa` created by Terraform, and save it on directory `/src/productcatalogservice`.
    - Update your JSON key file name on [.gitignore](/.gitignore), [Dockerfile](/src/productcatalogservice/Dockerfile), and [code](/src/productcatalogservice/server.go).

6. Configuring Cloud SQL

    - Terraform has created Cloud SQL instance and service account needed by the application.
    - Create Kubernetes secret
        ```
        kubectl create secret generic order-secret \
            --from-literal=db_user=root \
            --from-literal=db_password=<GCP_project_ID> \
            --from-literal=db_name=order
        ```
    - Update project ID for Kubernetes service account annotation on [yaml](/kubernetes-manifests/checkoutservice.yaml).
    - Update Cloud SQL instance connection name on [yaml](/kubernetes-manifests/checkoutservice.yaml) and [code](/src/checkoutservice/main.go).

7. Enable Google Container Registry (GCR) on your GCP project and configure the
    `docker` CLI to authenticate to GCR:

    ```sh
    gcloud services enable containerregistry.googleapis.com
    ```

    ```sh
    gcloud auth configure-docker -q
    ```

8. You can turn off order load generator by setting `tasks > checkout` [here](/src/loadgenerator/locustfile.py) to 0.

9. In the root of this repository, run `skaffold run --default-repo=gcr.io/[PROJECT_ID]`,
    where [PROJECT_ID] is your GCP project ID.

    This command:

    - builds the container images
    - pushes them to GCR
    - applies the `./kubernetes-manifests` deploying the application to
      Kubernetes.

    **Troubleshooting:** If you get "No space left on device" error on Google
    Cloud Shell, you can build the images on Google Cloud Build: [Enable the
    Cloud Build
    API](https://console.cloud.google.com/flows/enableapi?apiid=cloudbuild.googleapis.com),
    then run `skaffold run -p gcb --default-repo=gcr.io/[PROJECT_ID]` instead.

10. Find the IP address of your application, then visit the application on your
    browser to confirm installation.

        kubectl get service frontend-external

    **Troubleshooting:** A Kubernetes bug (will be fixed in 1.12) combined with
    a Skaffold [bug](https://github.com/GoogleContainerTools/skaffold/issues/887)
    causes load balancer to not to work even after getting an IP address. If you
    are seeing this, run `kubectl get service frontend-external -o=yaml | kubectl apply -f-`
    to trigger load balancer reconfiguration.

11. Authorize the domain for Firebase Authentication
    - Go to **Authentication** section on the Firebase Console and enable Sign-in method: Google.
    - Add the IP address of your deployed application  to the **Authorized domains.**

### Cleanup

You can run `skaffold delete` to clean up the deployed resources.

## Conferences featuring Online Boutique

- [Google Cloud Next'18 London – Keynote](https://youtu.be/nIq2pkNcfEI?t=3071)
  showing Stackdriver Incident Response Management
- Google Cloud Next'18 SF
  - [Day 1 Keynote](https://youtu.be/vJ9OaAqfxo4?t=2416) showing GKE On-Prem
  - [Day 3 – Keynote](https://youtu.be/JQPOPV_VH5w?t=815) showing Stackdriver
    APM (Tracing, Code Search, Profiler, Google Cloud Build)
  - [Introduction to Service Management with Istio](https://www.youtube.com/watch?v=wCJrdKdD6UM&feature=youtu.be&t=586)
- [KubeCon EU 2019 - Reinventing Networking: A Deep Dive into Istio's Multicluster Gateways - Steve Dake, Independent](https://youtu.be/-t2BfT59zJA?t=982)

---

This is not an official Google project.

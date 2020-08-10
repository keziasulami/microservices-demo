/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
    project = var.project
}

resource "google_storage_bucket" "product_images" {
    name        = "${var.project}-product-images"
    location    = var.region

    # delete bucket and contents on destroy.
    force_destroy = true
}

# Make bucket public readable.
resource "google_storage_bucket_acl" "product_images_acl" {
    bucket          = google_storage_bucket.product_images.name
    predefined_acl  = "publicRead"
}

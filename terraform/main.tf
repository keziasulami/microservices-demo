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
    location    = "ASIA-SOUTHEAST1" # Singapore

    # delete bucket and contents on destroy.
    force_destroy = true
}

resource "google_storage_bucket_object" "product_images" {
    count           = length(var.product_images)
    name            = trimprefix(element(var.product_images, count.index), var.product_images_path)
    source          = element(var.product_images, count.index)
    bucket          = google_storage_bucket.product_images.name
    content_type    = "image/jpeg"
}

# Make bucket public readable.
resource "google_storage_bucket_acl" "product_images_acl" {
    bucket          = google_storage_bucket.product_images.name
    predefined_acl  = "publicRead"
}

# Make object public readable.
resource "google_storage_object_acl" "product_images_acl" {
    count           = length(var.product_images)
    bucket          = google_storage_bucket.product_images.name
    object          = google_storage_bucket_object.product_images[count.index].output_name
    predefined_acl  = "publicRead"
}

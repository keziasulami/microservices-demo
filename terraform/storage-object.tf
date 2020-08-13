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

resource "google_storage_bucket_object" "product_image" {
    count           = length(var.product_image)
    name            = trimprefix(element(var.product_image, count.index), var.product_image_path)
    source          = element(var.product_image, count.index)
    bucket          = google_storage_bucket.product_image.name
    content_type    = "image/jpeg"
}

# Make object public readable.
resource "google_storage_object_acl" "product_image_acl" {
    count           = length(var.product_image)
    bucket          = google_storage_bucket.product_image.name
    object          = google_storage_bucket_object.product_image[count.index].output_name
    predefined_acl  = "publicRead"
}

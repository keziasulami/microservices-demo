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
 
variable "project" {
    type    = string
}

variable "product_images_path" {
    type    = string
    default = "../src/frontend/static/img/products/"
}

variable "product_images" {
    default = [
        "../src/frontend/static/img/products/STOJO-pocket-cup-12-oz2.jpg",
        "../src/frontend/static/img/products/Petit_Monkey_._Set_Of_5_Nesting_Dolls_._Dripped2_900x900.jpg",
        "../src/frontend/static/img/products/sony-walkman-40-anniversary-3.jpeg",
        "../src/frontend/static/img/products/7829154_060156d0-abe3-4a06-9f73-a0f3e1b0d9e0_2048_0.jpg",
        "../src/frontend/static/img/products/1568042845-Cactus_mix_yellow_2048x.jpg",
        "../src/frontend/static/img/products/ed0e62b4-89a0-4c81-b53c-8b14db5dca7f_1.eb653d835bb566bd8aecc566cf2384d4.jpg"
    ]
}

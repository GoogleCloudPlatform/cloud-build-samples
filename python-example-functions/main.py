# Copyright 2020 Google, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START cloudbuild_python_function]
def hello_world(request):
    name = "World"

    request_json = request.get_json(silent=True)
    request_args = request.args

    if request_json:
        name = request_json.get("name")
    if request_args:
        name = request_args.get("name") 

    return f"Hello {name}!"
# [END cloudbuild_python_function]
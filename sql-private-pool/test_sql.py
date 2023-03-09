# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import app
import pytest
import sqlalchemy
from app import connect_db
from flask import Flask


@pytest.fixture
def client():
    return app.app.test_client()


def test_dbconnect():
    db = app.connect_db()
    try:
        with db.connect() as conn:
            _ = conn.execute(sqlalchemy.text("SELECT NOW() as now")).scalar()
            print("Connection successful.")
    except Exception as ex:
        print(f"Connection not successful: {ex}")


def test_frontend(client):
    response = client.get("/")
    text = response.data.decode("UTF-8")
    print(text)
    assert response.status_code == 200
    assert "Time" in text

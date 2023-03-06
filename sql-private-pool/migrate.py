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

import os

import app
import sqlalchemy

db_type = os.environ.get("DATABASE_TYPE", "postgres")


def migrate():
    db = app.connect_db()
    with db.connect() as conn:
        if db_type == "mssql":
            now_stmt = "SELECT getdate() as now"
        else:
            now_stmt = "SELECT NOW() as now"

        now = conn.execute(sqlalchemy.text(now_stmt)).scalar()
        print(f"Performed migration at {now}")


print("Apply migration...")
migrate()

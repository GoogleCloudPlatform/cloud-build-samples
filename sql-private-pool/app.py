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
from flask import Flask, render_template
import sqlalchemy


db_name = os.environ.get("DATABASE_NAME", None)
db_user = os.environ.get("DATABASE_USER", None)
db_pass = os.environ.get("DATABASE_PASS", None)

# TCP Connections (Note: Unix Sockets not supported for Private Pools)
db_host = os.environ.get("DATABASE_HOST")
db_port = os.environ.get("DATABASE_PORT", 5432)
db_type = os.environ.get("DATABASE_TYPE", "postgres")

app = Flask(__name__)


def connect_db():

    # Helper for different database types
    if db_type == "postgres":
        drivername = "postgresql+pg8000"
    elif db_type == "mysql":
        drivername = "mysql+pymysql"
    elif db_type == "mssql":
        drivername = "mssql+pytds"
    else:
        raise ValueError("Unknown database type provided.")

    if db_host and db_port:
        settings = {"host": db_host, "port": db_port}
    else:
        raise ValueError("No Socket/Dir nor Host/Port provided.")

    db = sqlalchemy.create_engine(
        sqlalchemy.engine.url.URL.create(
            drivername=drivername,
            username=db_user,
            password=db_pass,
            database=db_name,
            **settings,
        )
    )
    return db


@app.get("/")
def main():
    try:
        db = connect_db()
        with db.connect() as conn:
            if db_type == "mssql":
                now_stmt = "SELECT getdate() as now"
            else:
                now_stmt = "SELECT NOW() as now"

            now = conn.execute(sqlalchemy.text(now_stmt)).scalar()
            return render_template(
                "index.html",
                success=True,
                message=f"Successful connection. Database Time: {now}",
            )
    except Exception as e:
        return (
            render_template(
                "index.html", success=False, message=f"Connection not successful: {e}"
            ),
            500,
        )


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

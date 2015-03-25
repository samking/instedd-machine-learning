# REST Endpoints #

| **Description** | **HTTP Method** | **URI** | **Arguments** | **Priviliges Required** | **Response Header** Success/Fail | **Response Body** Success/Fail |
|:----------------|:----------------|:--------|:--------------|:------------------------|:---------------------------------|:-------------------------------|
| **Users** |
| Create New User | POST | /users.xml | `*user[login], *user[email], *user[password], *user[password_confirmation]` |  | 201 / 422 | User / Errors |
| View Users | GET | /users.xml |  | Admin | 200 | Users |
| Toggle User's Admin Status | PUT | /users/toggle\_admin.xml |  | Admin |  200 / 422 | / Errors |
| Delete User | DELETE | /users/{id}.xml |  | Owner | 200 / 422 |  |
| **Database Tables and Machine Learning** |
| View database tables (users see their registered tables; admins see all tables) | GET | /datasets.xml |  | User, OAuth Access Token | 200 | Datasets |
| View Database Table | GET | /datasets/{id}.xml |  | Owner, OAuth Access Token | 200 | Database Table |
| Create Database Table | POST | /datasets.xml | `*dataset[name], *dataset[remote_db_service]` | User, OAuth Access Token | 201 / 422 | Database Table / Errors |
| Add Data To Table | PUT | /datasets/{id}.xml | `*`data\_url | Owner, OAuth Access Token |200 / 422 | / Errors |
| Remove Data From Table (blank column argument deletes whole row) | PUT | /datasets/{id}.xml | `*`remove\_rows, remove\_cols | Owner, OAuth Access Token |200 / 422 | / Errors |
| Run Machine Learning | PUT | /datasets/{id}.xml | `*service, *learn_rows` | Owner, OAuth Access Token |200 / 422 | / Errors |
| Delete Table | DELETE | /datasets/{id}.xml |  | Owner, OAuth Access Token | 200 |  |
| Delete Remote Table (normally done by Delete Table; this is used when something gets out of sync) | DELETE | /datasets/cleanup.xml | `*table_to_remove, *removal_db` | Admin, OAuth Access Token |200 |  |
| **OAuth** |
| View currently granted OAuth access tokens | GET | /oauth\_clients/tokens.xml |   | User | 200 | Tokens |
|View registered OAuth clients | GET | /oauth\_clients/clients.xml |   | User | 200 | Clients|
| Delete an OAuth Client | DELETE | /oauth\_clients/{id} |   | Owner | 200 |  |
| Create an OAuth Client | POST | /oauth\_clients | `*client_application[name], *client_application[url], *client_application[callback_url], client_application[support_url]` | User | 201/422 | Client Application / Errors |
|  |  | /oauth/test\_request |   |  |  |  |
| Get a request token from a consumer signature | POST | /oauth/request\_token | ??? | OAuth Consumer Signature | 200/401 | Request Token |
| Get an access token from an (authorized) request token  | POST | /oauth/access\_token | ??? | OAuth Request Token | 200/401 | Access Token |
| Authorize a Request Token | POST | /oauth/authorize | `*`oauth\_token, `*`authorize=1 | Owner | ??? | ??? |
| Revoke an OAuth Token | POST | /oauth/revoke | `*`token | Owner | ??? | ??? |
| Invalidate | ??? | /oauth/invalidate | ??? | OAuth Access Token | ??? | ??? |
| Capabilities | ??? | /oauth/capabilities | ??? | OAuth Access Token | ??? | ??? |



`*`: required argument

Valid remote DB services: sdb, google\_storage
Valid machine learning services: calais, google\_prediction\_train, google\_prediction\_check\_training, google\_prediction\_predict

Note: there is also a web interface available.  Just don't use the .xml extension.

## Privileges ##
"User": You must be logged in

"Owner": You must own the data and authenticate.  Admins are considered the owners of everything.

"Admin": You must be an administrator.  The first user created is an administrator, and that user can make more.

Authenticate using HTTP Basic.

OAuth Access Tokens must have the necessary user privileges.  Ie, a non-admin OAuth token can't do admin only actions.
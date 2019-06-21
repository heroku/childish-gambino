# How to Build an Add-on!
My example reference implementation of a Heroku Addon. It currently supports provisioning, OAuth Grant Token Exchange, deprovisioning, SSO, and freestyle rapping.

![picture alt](https://pre00.deviantart.net/0533/th/pre/i/2018/276/d/5/childish_gambino_banner_by_blackflim-dcoh1c2.png)
## Definitions:
- _Resource_: Instance of an Add-on when provisioned by Heroku, or single relationship between app and addon.
- _Slug_: id of add-on. This value is immutable.
- _Password_ - fetched from env var in Heroku
(USED FOR BASIC AUTH)
- _addon-manifest.json_ or _manifest_: metadata config file which allows pushing to Heroku Elements marketplace.
- _OAuth_grant_token_: grant code given by Heroku during the provision request to verify and authenticate addon with Platform API.
- _Platform API for partners_: subset of the platform API that an addon provider can access once authenticated

## *>> BEGIN FLOW >>*

On an app, Heroku User does:
> heroku addons:create childish-gambino

- Fires off provisioning api v3 =~ Add-on partner api
- Note: doing async only
    -  allows time for setup/notifies Heroku on completion


## Provisioning Request
[ HEROKU ] ---POST---> [ <ADD-ON_URL>/heroku/resources ]

- Needs basic auth (slug:password)
- Sends us parameters:
  - heroku_uuid
  - OAuth_Grant_Code (to be used in grant exchange)
- Creates Resource model
- Responds with 202 - accepted


## Grant code exchange
To access Platform API for Partners:

[ ADDON ] ----POST-- -> [ id.heroku.com/oauth/token ]

Request Body:
```
{ "client_secret": "1234abc",
  "code": resource.oauth_grant_code,
  "grant_type": "authorization_code"
}
```
Response:

```
HTTP/1.1 200 OK
{
  "access_token": "2af695e0-93e3-4821-ac2e-95f68435f128",
  "refresh_token": "95a242fe-4c4a-4059-bc06-512de9672619",
  "expires_in": 28800,
  "token_type": "Bearer"
}
```
- Allows for resource scoped access - relevant to created resource only
 - Kicks off Sidekiq job to exchange grant code for access token and secret token
 - **THESE VALUES SHOULD BE ENCRYPTED IN STORAGE AT REST!!**
 - Also kicks off job to update as provisioned

## Set Config Var & mark as provisioned
A. Set config var on app
- PATCH to `api.heroku/addons/heroku-uuid/config`
- Check by seeing config var set in Heroku

B. Mark addon as provisioned
- POST TO  `api.heroku.com/:heroku-uuid/actions/provision`
- Can check this by hitting api endpoint: `heroku api GET /addons/name`

## SSO Redirect from Heroku
**User can SSO from dashboard or via cli: `heroku addons:open`**

[ HEROKU ] ---POST---> [ <ADDON_URL>/sso/login ]

(Form-encoded post to <addons_url>/sso/login)

- Generates a SHA token with (resource id + salt + timestamp)
- Salt generated in the manifest
    - Compares resource token from request, to computed one
    - If equivalent, then display dashboard successfully with resource info!
- Sent over SSL so POST body cannot be seen

## Links and Resources:
- [What is an addon?](https://devcenter.heroku.com/articles/what-is-an-add-on)
- [Building an Addon](https://devcenter.heroku.com/articles/building-an-add-on)
- [Addon Provisioning API](https://devcenter.heroku.com/articles/add-on-partner-api-reference)
- [Platform API for Partners](https://devcenter.heroku.com/articles/add-on-partner-api-reference)
- [Creating and receiving webhooks](https://devcenter.heroku.com/articles/addon-webhooks)
- [Logging](https://devcenter.heroku.com/articles/accessing-app-logs)


# Reguler Routes

https://estore-demo-api.herokuapp.com/api/:locale(en|ar)

- Sessions Routes:

  - Post “/sessions” for login
  - Patch “/sessions” for updating expired access token

- User Routes:

  - Post “/users” for creating user
  - Get “/users” for getting current user information
  - Patch “/users” for updating current user information
  - Post "/users/uploads" for creating authorized link to upload user avatar on amazon s3
  - Patch "/users/uploads" for linking uploaded avatar with user record
  - Delete "/users/uploads" for removing user avatar

- Passwords Routes:

  - Post "/forget_password" for sending an email with reset token
  - Get "/forget_password" for validating reset token
  - Patch "/forget_password" for setting new password by using reset token
  - Patch "/reset_password" for setting new password by using old password

- Items Routes:

  - Get "/items" for items
  - accepted query params:
    - paginate: {page: 1, per: "default 20" }
    - order_by_recent: boolean
    - id: string
    - name: string
    - category_id: string << return items belongs to category id >>
    - cards: boolean << return only items of type_name=card>>
    - has_discount: boolean << items that have discount >>
    - order_by_best_sales: boolean
    - order_by_high_price: boolean
    - order_by_low_price: boolean
    - pinned: boolean

- Categories Routes:

  - Get "/categories" for categories
  - accepted query params:
    - paginate: {page: 1, per: "default 20" }
    - order_by_recent: boolean
    - id: string
    - name: string
    - primary: boolean
    - pinned: boolean

- Cart Routes:

  - Get "/cart" for user cart
  - Post "/sync" for sync server cart with client cart

- Cart Items Routes

  - Post "/cart_items" for add item to cart
  - Patch "/cart_items" for updating item in cart
  - delete "/cart_items" for removing item from cart

- Order Routes:

  - Post "/orders" for cart checkout and creating an order object
  - Delete "/orders" for destroying order object
  - Get "/orders" for getting user completed orders
  - accepted query params:
    - paginate: {page: 1, per: "default 20" }
    - order_by_recent: boolean
    - id: string
    - cards: boolean << only orders that contain items of type card >>
    - delivered: boolean << only delivered orders >>
    - pending_delivery: boolean << only pending orders >>
    - failed_delivery: boolean << only failed delivery orders >>

- Payments Routes:

  - Post "/payments" for process payment.
  - Patch "/payments" for process payment after bank 3d authentication

# Dashboard Routes

https://estore-demo-api.herokuapp.com/api/:locale/dashboard

- Users Routes:

  - Patch "/users" for updating user data
  - Get "/users" for geting users data
  - accepted query params:
    - paginate: {page: 1, per: "default 20" }
    - order_by_recent: boolean
    - id: string
    - blocked: boolean << list of blocked users >>
    - staff: boolean << list of staff users >>
    - phone_no: string || integer
    - email: string
    - city: string
    - gender: string
    - age_below: integer
    - age_above: integer
    - age_between: array[]
  - Post "/users/avatar_uploads" for obtaining authorized link for uploading to s3
  - Patch "/users/avatar_uploads" for linking updating uploaded avatar with user record
  - Delete "/users/avatar_uploads" for removing a user avatar

- Authorizations Routes:

  - Patch "/authorizations" to update a user authorizations

- Staff Actions Routes:

  - Get "/staff_actions"
  - accepted query params:
    - paginate: {page: 1, per: "default 20" }
    - order_by_recent: boolean
    - id: string
    - action_type: string
    - model_name: string
    - model_id: string
    - by_user_id: string

- Items Routes:

  - Post "/items" for creating new item
  - Patch "/items" for updating item
  - Delete "/items" for deleting item
  - Post "/items/images_uploads" for obtaining authorized link for updating to s3
  - Patch "/items/images_uploads" for linking uploaded image with item record
  - Delete "/items/images_uploads" for deleting image from an item

- Cards Routes:

  - Post "/cards" for creating a card belongs to an item
  - Patch "/cards" for updating card
  - Delete "/cards" for deleting card
  - Get "/cards" for getting cards ( only unsold cards )
  - accepted query params:
    - paginate: {page: 1, per: "default 20" }
    - order_by_recent: boolean
    - id: string

- Orders Routes:

  - Get "/orders" for a list of completed orders
  - accepted query params:
    - paginate: {page: 1, per: "default 20" }
    - order_by_recent: boolean
    - id: string
    - cards: boolean << only orders that contain items of type card >>
    - delivered: boolean << only delivered orders >>
    - pending_delivery: boolean << only pending delivery orders >>
    - failed_delivery: boolean << only failed delivery orders >>
    - user_phone_no: string || integer
    - user_id: string

- Order Items Routes:

  - Patch "/order_items" for updating delivery status of an item

- Notifications Routes:

  - Patch "/notifications" for marking notification seen or unseen
  - Get "/notifications" for list of notifications
  - accepted query params:
    - paginate: {page: 1, per: "default 20" }
    - order_by_recent: boolean
    - id: string
    - seen: boolean
    - unseen: boolean
    - msg_type: string

- Uploads Routes:
  general route for uploads where record type and record id should be supplied manualy

  - Post "/uploads" for creating authorized link for uploads to s3
  - Patch "/uploads" for linking record with the uploaded file
  - Delete "/uploads" for deleting a file from a record

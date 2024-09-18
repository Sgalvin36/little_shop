# Little Shop BE

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites] (#prerequisites)
3. [Setup Instructions](#setup-instructions)
4. [API Endpoints](#API-Endpoints)
5. [Contributors](#contributors)

## Overview
Little Shop BE is an API application that manages an e-commerce platform.n It provides endpoits to interact with merchants, items, customers, and transactions. The API uses various CRUD operations and custom search endpoints to facilitate communication with a front-end client.

The project follows RESTful API principles, with non-RESTful search functionality for specific merchant and item queries.

### Prerequisites
Make sure you have the following installed:
- Ruby 3.2.2
- Rails 7.1.2
- PostgreSQL

### Setup Instructions
1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd little_shop
   bundle install
   rails db:{drop,create,migrate,seed}
   rails db:schema:dump 

### API Endpoints
  This section should include details about the main endpoints. You can give a short overview or link to your detailed API documentation. Example format:

  - Merchants
    - GET /api/v1/merchants - Returns a list of all merchants.
    - GET /api/v1/merchants/:id

  - Items
    - GET /api/v1/items - Returns a list of all items.
    - POST /api/v1/items - Creates a new item.
    - PATCH /api/v1/merchants/:id - Updates item 
    - DELETE /api/v1/merchants/:id - Deletes item

  - Search Functionality
    - GET /api/v1/merchants/find - Search for a merchant by name using query parameters.
    - GET /api/v1/items/find_all - Search for items based on price or name criteria.



### Contributors
- [Shane Galvin](http://github.com/Sgalvin36)
- [Kyle Delaney](https://github.com/kylomite)
- [Joel Davalos](http://github.com/jdavalos98)
- [Kaelin Salazar](https://github.com/kaelinpsalazar)
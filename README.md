## **👉 TO IMPORT REQUESTS INTO POSTMAN:**

**Import the file** `curl-postman.json` **into Postman.**


# --- MENUS ---

# GET /api/menus
curl -X GET http://localhost:3000/api/menus

# POST /api/menus
curl -X POST http://localhost:3000/api/menus \
  -H "Content-Type: application/json" \
  -d '{"name": "Menu do Dia"}'

# PATCH /api/menus/:id
curl -X PATCH http://localhost:3000/api/menus/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "Menu Atualizado"}'

# PUT /api/menus/:id
curl -X PUT http://localhost:3000/api/menus/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "Menu Substituído"}'

# DELETE /api/menus/:id
curl -X DELETE http://localhost:3000/api/menus/1


# --- MENU ITEMS ---

# GET /api/menu_items
curl -X GET http://localhost:3000/api/menu_items

# POST /api/menu_items
curl -X POST http://localhost:3000/api/menu_items \
  -H "Content-Type: application/json" \
  -d '{"name": "Pizza", "price": 25.0, "menu_id": 1}'

# PATCH /api/menu_items/:id
curl -X PATCH http://localhost:3000/api/menu_items/1 \
  -H "Content-Type: application/json" \
  -d '{"price": 27.0}'

# PUT /api/menu_items/:id
curl -X PUT http://localhost:3000/api/menu_items/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "Pizza Grande", "price": 30.0, "menu_id": 1}'

# DELETE /api/menu_items/:id
curl -X DELETE http://localhost:3000/api/menu_items/1


# --- RESTAURANTS ---

# GET /api/restaurants
curl -X GET http://localhost:3000/api/restaurants

# POST /api/restaurants
curl -X POST http://localhost:3000/api/restaurants \
  -H "Content-Type: application/json" \
  -d '{"name": "Restaurante A", "address": "Rua 123"}'

# PATCH /api/restaurants/:id
curl -X PATCH http://localhost:3000/api/restaurants/1 \
  -H "Content-Type: application/json" \
  -d '{"address": "Rua Atualizada"}'

# PUT /api/restaurants/:id
curl -X PUT http://localhost:3000/api/restaurants/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "Restaurante B", "address": "Nova Rua 456"}'

# DELETE /api/restaurants/:id
curl -X DELETE http://localhost:3000/api/restaurants/1




users/{userId}
├── email
├── displayName
├── favorites: [recipeId]
├── groups: [groupId]
├── isPremium: true/false

recipes/{recipeId}
├── title
├── authorId
├── isPublic: true/false
├── groupsShared: [groupId]     👈 Groupes avec accès
├── createdAt
├── steps
├── ingredients
├── images
├── utensils
├── preparationTime
├── cookingTime
├── description

groups/{groupId}
├── name
├── members: [userId]
├── createdAt

likes/{recipeId}
├── {userId}: true                  👈 Simple map de likes par utilisateur
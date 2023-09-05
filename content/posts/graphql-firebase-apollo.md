---
title: "GraphQL with Firebase Cloud Functions and Apollo Server"
date: 2023-08-01T19:23:13+05:30
draft: false # Set 'false' to publish
description: ""
categories:
- Swift
tags:
- graphql
---

This tutorial will guide you through setting up a GraphQL server using Firebase Cloud Functions and Apollo Server. This will let you fetch data through a single endpoint, simplifying your iOS app’s backend.

## Setup and Installation

### Initialize Firebase

```bash
$ firebase init
```

Choose "Functions" when prompted:

```bash
❯ ◯ Functions: Configure and deploy Cloud Functions
```

### Language Selection

Select JavaScript for this tutorial:

```bash
❯ JavaScript
```

### Installing Dependencies

Navigate to the `functions` directory:

```bash
$ cd functions
```

Install required packages:

```bash
$ npm install && npm install apollo-server-express express graphql
```

## Building the GraphQL API

### Setting Up Express

In `index.js`, setup an Express app:

```javascript
const functions = require("firebase-functions");
const express = require("express");
const app = express();

exports.graphql = functions.https.onRequest(app);
```

### Defining Schema

Create a new file `schema/schema.js`:

```javascript
const { gql } = require('apollo-server-express');

const typeDefs = gql`
  type Contact {
    id: ID!
    name: String!
    email: String!
  }

  type Query {
    contacts: [Contact]
  }
`;

module.exports = typeDefs;
```

### Connecting to Firebase

Create a new file `database/database.js`:

```javascript
const admin = require("firebase-admin");

var serviceAccount = require("../path/to/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://<YOUR-DATABASE-NAME>.firebaseio.com"
});

const db = admin.firestore();

module.exports = db;
```

### Setup Resolvers

Create a new file `resolvers/resolvers.js`:

```javascript
const db = require('../database/database');

const resolvers = {
  Query: {
    contacts: async () => {
      const contacts = [];
      const snapshot = await db.collection('contacts').get();
      snapshot.forEach((doc) => {
        contacts.push(doc.data());
      });
      return contacts;
    },
  },
};

module.exports = resolvers;
```

### Integrating Apollo Server

In `index.js`, tie it all together:

```javascript
const functions = require("firebase-functions");
const express = require("express");
const { ApolloServer } = require("apollo-server-express");
const typeDefs = require("./schema/schema");
const resolvers = require("./resolvers/resolvers");

const app = express();

const server = new ApolloServer({ typeDefs, resolvers });
server.applyMiddleware({ app, path: '/', cors: true });

exports.graphql = functions.https.onRequest(app);
```

## Testing and Deployment

### Local Testing

```bash
$ firebase emulators:start --only functions
```

### Deploy to Firebase

```bash
$ firebase deploy --only functions
```

You've now successfully built and deployed a GraphQL server using Firebase Cloud Functions and Apollo Server!

> **Note**: This approach is generally not recommended for high-scale, production applications as each function instance handles one request at a time.

# Wallet Transactional System API

This project is a Rails-based API that facilitates the management of wallets and transactions between various entities such as Users, Teams, and Stocks. The system uses JWT for authentication and integrates with the Latest Stock Price API for fetching stock prices.

## Table of Contents

-   [Overview](#overview)
-   [Architecture](#architecture)
-   [Features](#features)
-   [Models](#models)
-   [Database Structure](#database-structure)
-   [Authentication](#authentication)
-   [LatestStockPrice Library](#lateststockprice-library)
-   [Setup Instructions](#setup-instructions)
-   [Seed Data](#seed-data)
-   [API Usage](#api-usage)
    -   [Authentication Endpoints](#authentication-endpoints)
    -   [Wallet Endpoints](#wallet-endpoints)
    -   [Transaction Endpoints](#transaction-endpoints)
-   [Testing](#testing)
-   [Future Enhancements](#future-enhancements)

## Overview

This API is designed to manage financial transactions within a system where various entities (such as Users, Teams, and Stocks) have associated wallets. The system ensures that all transactions comply with business rules, such as proper validation of credits and debits. Additionally, the system integrates JWT for secure API access and includes a custom library to fetch real-time stock prices.

## Architecture

The application is architected around several core components:

-   **Entities**: Different types of entities like Users, Teams, and Stocks, each associated with a wallet.
-   **Wallets**: Each entity owns a wallet that holds a balance. Wallets are responsible for keeping track of all credits and debits.
-   **Transactions**: Managed through a base transaction model, with specific types of transactions (Credit and Debit) implemented via Single Table Inheritance (STI).
-   **JWT Authentication**: Provides secure access to the API, ensuring that only authenticated users can perform transactions.
-   **LatestStockPrice Library**: A custom library that interacts with the Latest Stock Price API to fetch stock prices.

## Features

-   **Wallet Management**: Each entity can have its own wallet, supporting deposits and withdrawals.
-   **Transaction Validation**: All transactions are validated to ensure they meet business rules, such as ensuring credits have no source wallet and debits have no target wallet.
-   **JWT Authentication**: API endpoints are protected using JWT tokens, ensuring that only authenticated users can interact with the system.
-   **Stock Price Fetching**: The system includes a library to fetch and manage stock prices via an external API.

## Models

The system includes the following key models:

-   **User, Team, Stock**: These are entities that can have associated wallets.
-   **Wallet**: Represents the balance for an entity and tracks all associated transactions.
-   **Transaction**: The base model for all transactions, with specific types being Credit and Debit.

## Database Structure

The database is designed to support the relationships between entities, wallets, and transactions. Key tables include:

-   **Wallets**: Stores the balance and association to an entity.
-   **Transactions**: Tracks each financial movement, whether a credit or debit, between wallets.

## Authentication

The API uses JWT (JSON Web Token) for authentication. Users log in to receive a token, which must be included in the header of subsequent API requests. This ensures that all operations are performed by authenticated users only.

## LatestStockPrice Library

A custom library is included to interact with the Latest Stock Price API. It allows the system to fetch current stock prices, either for individual stocks, multiple stocks, or all available stocks. This functionality is crucial for applications involving financial data tied to stock market values.

## Setup Instructions

1. **Clone the Repository**: Clone the project repository to your local machine.
2. **Install Dependencies**: Run `bundle install` to install all required gems.
3. **Database Setup**: Run `rails db:create db:migrate` to set up the database.
4. **Environment Variables**: Set up any required environment variables, particularly for JWT secrets and API keys for the stock price library.
5. **Start the Server**: Run `rails server` to start the application.

## Seed Data

To get started with some initial data, you can run the provided seed script using `rails db:seed`. This will create sample users, wallets, and transactions to help you test the API.

## API Usage

### Authentication Endpoints

-   **Login**: Obtain a JWT token by providing valid user credentials.
-   **Logout**: Invalidate the current JWT token (this is typically managed by the client by deleting the token).

### Wallet Endpoints

-   **Create Wallet**

    -   **Endpoint**: `POST /api/wallets`
    -   **Description**: Create a wallet for a specific entity.
    -   **Request Parameters**:
        -   `walletable_type` (string, required): The type of entity (e.g., "User", "Team", "Stock").
        -   `walletable_id` (integer, required): The ID of the entity.
        -   `balance` (decimal, optional): The initial balance for the wallet (default is 0.0).
    -   **Response**: Returns the created wallet's details, including its initial balance.

-   **View Wallet**

    -   **Endpoint**: `GET /api/wallets/:id`
    -   **Description**: Retrieve the balance and transaction history of a wallet.
    -   **Request Parameters**:
        -   `id` (integer, required): The ID of the wallet.
    -   **Response**: Returns the wallet's current balance and a list of transactions associated with it.

-   **List Wallets**
    -   **Endpoint**: `GET /api/wallets`
    -   **Description**: Retrieve a list of all wallets associated with the current user.
    -   **Response**: Returns a list of wallets with their balances and basic information.

### Transaction Endpoints

-   **Create Transaction**

    -   **Endpoint**: `POST /api/transactions`
    -   **Description**: Perform a credit or debit transaction between wallets.
    -   **Request Parameters**:
        -   `amount` (decimal, required): The amount of money to be transferred.
        -   `source_wallet_id` (integer, optional): The ID of the source wallet (should be `nil` for credits).
        -   `target_wallet_id` (integer, optional): The ID of the target wallet (should be `nil` for debits).
        -   `type` (string, required): The type of transaction, either "Credit" or "Debit".
    -   **Response**: Returns the details of the created transaction.

-   **View Transaction**
    -   **Endpoint**: `GET /api/transactions/:id`
    -   **Description**: Retrieve details of a specific transaction.
    -   **Request Parameters**:
        -   `id` (integer, required): The ID of the transaction.
    -   **Response**: Returns the transaction's details, including the amount, type, and involved wallets.

## Testing

To test the API, you can use Postman or any other API testing tool. Ensure you include the JWT token in the Authorization header for any protected routes.

## Future Enhancements

-   **Multi-Currency Support**: Extend the wallet system to handle multiple currencies.
-   **Transaction Reversal**: Implement a system to reverse transactions in case of errors.
-   **Advanced Reporting**: Add reporting features to provide insights into transaction patterns.

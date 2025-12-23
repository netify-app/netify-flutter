# Netify Core

Core network inspection functionality for Flutter - client-agnostic.

This package provides the foundation for Netify network inspector, including:

- Network log data models
- Repository interfaces
- UI components
- Callback and filter systems
- Base adapter interface

## Usage

This package is not meant to be used directly. Instead, use one of the client-specific adapters:

- `netify_dio` - For Dio HTTP client
- `netify_http` - For dart:io http package
- `netify_graphql` - For GraphQL clients

## Features

- 📊 Network log entities
- 🎨 UI components (NetifyPanel, LogDetailPage)
- 🔌 Callback system for integrations
- 🎯 Smart filters for request capturing
- 🏗️ Adapter pattern for multiple HTTP clients

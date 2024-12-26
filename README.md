# Business Assets [![Codemagic build status](https://api.codemagic.io/apps/6738a16d90a1f90519e1e954/6738a16d90a1f90519e1e953/status_badge.svg)](https://codemagic.io/app/6738a16d90a1f90519e1e954/6738a16d90a1f90519e1e953/latest_build)

**Business Assets** was created as an innovative solution to facilitate the management of industrial assets and components. It offers a hierarchical view of the assets, components, and locations of companies, using an intuitive tree structure that simplifies navigation and monitoring. My mission is to ensure that you have quick and organized access to all the necessary information for efficient operation.

# Solution

I developed a Flutter application, available for Android devices through Firebase App Distribution.

To gain access to the application, please follow these steps:

1. Click the link below to join the open group: 
> https://appdistribution.firebase.dev/i/ae4341b7582c14d9
2. Once you join, you will receive instructions to download and install the app on your Android device.

### Demo Video

To see a demonstration of the Business Assets application in action, please watch the video below:

![Demo Video](./docs/demo.mp4)



### Development Methodology

To develop Business Assets, I used the **Kanban** methodology, which allows me to visualize the workflow, organize tasks efficiently, and maintain flexibility for adaptations during development. With Kanban, I can prioritize value deliveries for users and track the project's progress in real time. You can follow my progress on the [Business Assets Kanban](https://github.com/users/pretodev/projects/3).

### API

This project uses an API as a data source, available at: [https://fake-api.tractian.com](https://fake-api.tractian.com)

The API endpoints are:

```http
GET /companies
```
Returns all companies.

```http
GET /companies/:companyId/locations
```
Returns all locations of the company.

```http
GET /companies/:companyId/assets
```
Returns all assets of the company.

### User Interface

The design specifications are available through [Figma](https://www.figma.com/file/IP50SSLkagXsUNWiZj0PjP/%5BCareers%5D-Flutter-Challenge-v2?type=design&node-id=0%3A1&mode=design&t=puUgGuBG9v8leaSQ-1).

### Developer

This project is developed by [Silas Ribeiro](https://github.com/pretodev), a software engineer specialized in creating mobile applications with Flutter.


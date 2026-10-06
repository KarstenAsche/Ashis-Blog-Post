---
title: "Setting Up and Customizing a Docusaurus Project"
description: "Documentation of setting up a Docusaurus project based on a template – from repository creation and branching to the pull request."
slug: /project/docusaurus-setup
---

# Setting Up and Customizing a Docusaurus Project

In this article, I document the basic setup and customization of a Docusaurus project based on an existing template.

The goal was to use the template as a starting point for a new project, adjust the most important configuration values, and then integrate the changes through a dedicated feature branch and pull request.

## 1. Create a Repository from the Template

The first step was to create a new repository based on the existing Docusaurus template.

This provides the complete basic project structure without having to set up the application from scratch.


## 2. Clone the Repository Locally

After creating the repository, I cloned it to my local machine.

```bash
git clone https://github.com/KarstenAsche/Ashis-Blog-Post
```

Then I switched into the project directory:

```bash
cd C:\Users\karst\DeveloperAkademie\Projects\DocusaurusDA\Ashis-Blog-Post
```

## 3. Create a Feature Branch

The changes were not made directly on the main branch.

Instead, I created a dedicated feature branch:

```bash
git checkout -b feature/setup-blog
```

This keeps the setup changes isolated from the main branch and makes it possible to review and merge them later through a pull request.

## 4. Customize the Project Based on the Checklist

The main project setup was completed according to the provided project checklist.

### 4.1 Update `docusaurus.config.ts`

The central Docusaurus configuration is located in:

```text
docusaurus.config.ts
```

Several project-specific settings were updated there.

#### Update the Title and the Tagline

The site title was changed to match the new project.

Example:

```ts
title: 'Live Blog Karsten Asche',
tagline: 'Karsten Asche\'s personal blog about software development, DevOps, and cloud computing.',
```

#### Update the Default URL

The base project URL was changed according to the planned deployment target.

Example:

```ts
url: 'https://karstenasche.github.io',
```

### 4.2 Add `GIT_REPOSITORY_URL` to `.env.example`

To avoid hardcoding the repository URL in multiple places, a new environment variable was added.

Inside `.env.example`:

```env
GIT_REPOSITORY_URL=https://github.com/KarstenAsche/Ashis-Blog-Post
```

The `.env.example` file acts as a template for the required local environment configuration.

### 4.3 Create a TypeScript Variable for the Repository URL

A TypeScript variable was added to `docusaurus.config.ts` to read the value from `GIT_REPOSITORY_URL`.

Example:

```ts
const repositoryUrl = process.env.GIT_REPOSITORY_URL ?? "https://github.com/KarstenAsche/Ashis-Blog-Post"
```

If a fallback value is required, it can be defined like this:

```ts
const repositoryUrl =
  process.env.GIT_REPOSITORY_URL ??
  'https://github.com/KarstenAsche/Ashis-Blog-Post';
```

This makes the repository URL configurable from a single location.

### 4.4 Replace Hardcoded `editUrl` Values

All hardcoded `editUrl` entries were replaced with the newly created variable.

Example:

```ts
 editUrl:
    repositoryUrl,
```

This makes it much easier to change the repository URL later.

### 4.5 Update the Navbar

The navigation bar was updated with project-specific values.

The following elements were changed:

- Navbar title
- Logo and logo path

Example:

```ts
navbar: {
      title: 'Ashis Site',
      logo: {
        alt: 'My Site Logo',
        src: 'img/ka-logo.png',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Docs',
        },
        {
          href: repositoryUrl,
          label: 'Github',
          position: 'right',
        },
        ...(blogEnabled
          ? [{to: '/blog', label: 'Blog', position: 'left' as const}]
          : []),
      ],
}
```

### 4.6 Extend the Footer

A new footer item was added that links to the project overview.

Target path:

```text
docs/project/overview
```

Example:

```ts
{
  label: 'Project Overview',
  to: '/docs/project/overview',
},
```

### 4.7 Remove the Community Column

The default Community column was removed because it was not required for this project.

This keeps the footer cleaner and focused on project-related content.

### 4.8 Update the `More` Column

Inside the `More` section, the default GitHub URL was replaced with the URL of my own repository.

A link to the original template repository was also added.

This makes it clear which template was used as the foundation of the project.

Example:

```ts
{
  title: 'More',
  items: [
    {
      label: 'GitHub',
      href: gitRepositoryUrl,
    },
    {
      label: 'Template Repository',
      href: 'https://github.com/<template-repository>',
    },
  ],
},
```

### 4.9 Update the Copyright Message

The copyright message was customized and extended for the project.

Example:

```ts
copyright:
  `Copyright © ${new Date().getFullYear()} My Project. Built with Docusaurus.`,
```

Depending on the project, additional information such as the author, company, or template attribution can also be included.

## 5. Update the README

The `README.md` file was updated according to the project checklist.

Project-specific information was added and the default template content was adjusted where necessary.

Typical sections include:

- Project description
- Requirements
- Installation
- Starting the development server
- Creating a production build
- Deployment
- Repository structure
- Used template

## 6. Configure GitHub Settings for GitHub Actions

The required GitHub repository settings were configured so that GitHub Actions can build and deploy the project automatically.

Depending on the workflow, this may include:

- Checking GitHub Actions permissions
- Configuring workflow permissions
- Enabling GitHub Pages
- Selecting GitHub Actions as the deployment source
- Adding required secrets or repository variables

The exact configuration depends on the workflow used in the repository.

## 7. Test the Project Locally

After completing the changes, the project was tested locally.

First, the project dependencies were installed if they were not already available:

```bash
npm install
```

Then the local development server was started:

```bash
npm run start
```

By default, Docusaurus starts a local server that is usually available at:

```text
http://localhost:3000
```

During local testing, I checked the following points:

- The application starts without errors
- Title and tagline are correct
- The navbar is displayed correctly
- The logo loads correctly
- Footer links are available
- Documentation pages are accessible
- Links work as expected
- No obvious errors appear in the browser console

In addition to the development server, I also tested the production build:

```bash
npm run build
```

This verifies that the project can be successfully built for production.

The generated build can optionally be tested locally using:

```bash
npm run serve
```

## 8. Commit the Changes

After successful testing, all changes were added to the Git staging area:

```bash
git add .
```

Then I created a commit:

```bash
git commit -m "feat: setup docusaurus blog configuration"
```

## 9. Push the Feature Branch

The feature branch was pushed to GitHub:

```bash
git push -u origin feature/setup-blog
```

The `-u` option connects the local branch with the corresponding remote branch.

After that, future changes can simply be pushed with:

```bash
git push
```

## 10. Create a Pull Request

After pushing the branch, I created a pull request on GitHub.

The feature branch:

```text
feature/setup-blog
```

was compared against the project's main branch.

The pull request included a short summary of the changes.

Example:

```text
- Updated Docusaurus configuration
- Made repository URL configurable through an environment variable
- Updated navbar and footer
- Updated README
- Configured GitHub Actions
- Tested the project locally
```

After reviewing the changes, the pull request can be merged into the main branch.

## Result

After completing these steps, the Docusaurus project is fully configured and ready for further development.

The main project-specific settings are now centralized in the configuration, repository links can be managed through an environment variable, and the changes were introduced using a clean Git workflow:

```text
Template
   ↓
Repository
   ↓
Clone
   ↓
Feature Branch
   ↓
Configuration
   ↓
Local Testing
   ↓
Commit
   ↓
Push
   ↓
Pull Request
```

This provides a clean and maintainable foundation for continuing the project documentation and blog development.

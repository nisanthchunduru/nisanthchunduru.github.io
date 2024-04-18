# blog

This repository contains the source code of my [blog](https://nisanthchunduru.github.io)

The blog is built with [Hugo](https://gohugo.io/), a fast static site generator written in Go lang. Blog posts are authored in Notion https://inquisitive-bumper-4db.notion.site/blog_content-0f1b55769779411a95df1ee9b4b070c9?pvs=4 which serves as a CMS (Content Management System).

![image](https://github.com/nisanthchunduru/nisanthchunduru.github.io/assets/1789832/94294682-016f-4c8d-82bd-76855a5ffb63)

## Installation

First, clone the repository
```
cd ~/Projects/
git clone --recurse-submodules git@github.com:nisanthchunduru/blog.git
```

Install hugo
```
brew install hugo
```

To view the blog in your browser, run
```
hugo server --buildDrafts --watch
```
and visit http://localhost:1313

## Deployment

The blog is deployed from GitHub Actions
